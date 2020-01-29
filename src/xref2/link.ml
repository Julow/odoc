(* Second round of resolution tackles references and forward paths *)
open Odoc_model
open Lang

module Opt = struct
  let map f = function Some x -> Some (f x) | None -> None
end

let with_dummy_location v = Location_.
  { location = { file=""; start={line=0; column=0;}; end_={line=0; column=1} }
  ; value=v }

let rec should_reresolve : Paths.Path.Resolved.t -> bool =
 fun p ->
  let open Paths.Path.Resolved in
  match p with
  | `Identifier _ -> false
  | `Subst (x, y) -> should_reresolve (x :> t) || should_reresolve (y :> t)
  | `SubstAlias (x, y) -> should_reresolve (x :> t) || should_reresolve (y :> t)
  | `Hidden p -> should_reresolve (p :> t)
  | `Canonical (x, y) ->
      should_reresolve (x :> t) || should_resolve (y :> Paths.Path.t)
  | `Apply (x, y) ->
      should_reresolve (x :> t) || should_resolve (y :> Paths.Path.t)
  | `Alias (x, y) -> should_reresolve (x :> t) || should_reresolve (y :> t)
  | `Type (p, _)
  | `Class (p, _)
  | `ClassType (p, _)
  | `ModuleType (p, _)
  | `Module (p, _) ->
      should_reresolve (p :> t)

and should_resolve : Paths.Path.t -> bool =
 fun p -> match p with `Resolved p -> should_reresolve p | _ -> true

 let add_module_docs m expn =
  let open Odoc_model.Lang in
  match expn with
  | Module.Signature sg ->
    let doc = Signature.Comment (`Docs m.Module.doc) in
    Module.Signature (doc::sg)
  | _ -> expn

let type_path : Env.t -> Paths.Path.Type.t -> Paths.Path.Type.t =
 fun env p ->
  if not (should_resolve (p :> Paths.Path.t)) then p
  else
    let cp = Component.Of_Lang.(type_path empty p) in
    match Tools.lookup_type_from_path env cp with
    | Resolved (p', _) -> `Resolved (Cpath.resolved_type_path_of_cpath p')
    | Unresolved p -> Cpath.type_path_of_cpath p
    | exception e ->
        Format.fprintf Format.err_formatter
          "Failed to lookup type path (%s): %a\n%!" (Printexc.to_string e)
          Component.Fmt.model_path
          (p :> Paths.Path.t);
        p

and module_type_path :
    Env.t -> Paths.Path.ModuleType.t -> Paths.Path.ModuleType.t =
 fun env p ->
  if not (should_resolve (p :> Paths.Path.t)) then p
  else
    let cp = Component.Of_Lang.(module_type_path empty p) in
    (* Format.fprintf Format.err_formatter
      "Link.module_type_path: resolving %a\n%!" Component.Fmt.module_type_path
      cp; *)
    match Tools.lookup_and_resolve_module_type_from_path true env cp with
    | Resolved (p', _) ->
        (* Format.fprintf Format.err_formatter "It became: %a\n%!"
          Component.Fmt.resolved_module_type_path p'; *)
        `Resolved (Cpath.resolved_module_type_path_of_cpath p')
    | Unresolved _p ->
      failwith "Unresolved module type path" 
    | exception e ->
        Format.fprintf Format.err_formatter
          "Failed to lookup module_type path (%s): %a\n%!"
          (Printexc.to_string e) Component.Fmt.model_path
          (p :> Paths.Path.t);
        p

and module_path : Env.t -> Paths.Path.Module.t -> Paths.Path.Module.t =
 fun env p ->
  if not (should_resolve (p :> Paths.Path.t)) then p
  else
    let cp = Component.Of_Lang.(module_path empty p) in
    match Tools.lookup_and_resolve_module_from_path true true env cp with
    | Resolved (p', _) -> `Resolved (Cpath.resolved_module_path_of_cpath p')
    | Unresolved _p ->
      failwith "Unresolved module path" 
    | exception e ->
        Format.fprintf Format.err_formatter
          "Failed to lookup module path (%s): %a\n%!" (Printexc.to_string e)
          Component.Fmt.model_path
          (p :> Paths.Path.t);
        p

let rec unit (resolver : Env.resolver) t =
  let open Compilation_unit in
  Tools.is_compile := false;
  let initial_env =
    let m = Env.module_of_unit t in
    Env.empty |> Env.add_module t.id m
    |> Env.add_root (Paths.Identifier.name t.id) (Env.Resolved (t.id, m))
  in
  let initial_env = Env.set_resolver initial_env resolver in
  let (*rec*) resolve_units (units, env) imports =
    List.fold_right
      (fun import (imports, env) ->
        if List.mem import imports then (imports, env)
        else
          match import with
          | Import.Resolved root ->
              (* Format.fprintf Format.err_formatter "Found root: %s\n%!" (Odoc_model.Root.to_string root); *)
              let unit = resolver.resolve_unit root in
              let m = Env.module_of_unit unit in
              let env = Env.add_module unit.id m env in
              let env =
                Env.add_root
                  (Odoc_model.Root.Odoc_file.name root.Odoc_model.Root.file)
                  (Env.Resolved (unit.id, m))
                  env
              in
              (import :: imports, env)
          | Import.Unresolved (str, _) -> (
              match resolver.lookup_unit str with
              | Forward_reference ->
                  (* Format.fprintf Format.err_formatter "Didn't find: %s\n%!" str; *)
                  let env = Env.add_root str Env.Forward env in
                  (import :: imports, env)
              | Found f ->
                  (* Format.fprintf Format.err_formatter "Found: %s\n%!" str; *)
                  let unit = resolver.resolve_unit f.root in
                  let m = Env.module_of_unit unit in
                  let imported_already =
                    try
                      ignore (Env.lookup_module unit.id env);
                      true
                    with _ -> false
                  in
                  if imported_already then (imports, env)
                  else
                    let env = Env.add_module unit.id m env in
                    let env =
                      Env.add_root
                        (Odoc_model.Root.Odoc_file.name
                           f.root.Odoc_model.Root.file)
                        (Env.Resolved (unit.id, m))
                        env
                    in
                    (* Format.fprintf Format.err_formatter "Recursing...\n%!"; *)
                    (*let imports, env =
                      resolve_units (imports, env) unit.imports
                    in*)
                    (* Format.fprintf Format.err_formatter "Finished...\n%!"; *)
                    (Resolved f.root :: imports, env)
              | Not_found ->
                  Format.fprintf Format.err_formatter "Not found at all: %s\n%!"
                    str;
                  (import :: imports, env) ))
      imports (units, env)
  in

  let imports, env = resolve_units ([], initial_env) t.imports in
  (* Format.fprintf Format.err_formatter "Took %f seconds\n%!" (end_ -. start); *)
  let result =
    {
      t with
      content = content env t.content;
      imports;
      doc = comment_docs env t.doc;
    }
  in
  (* Format.fprintf Format.err_formatter "Avg length of modules: %f\n%!"
    (float_of_int !Env.len /. float_of_int !Env.n); *)

  result

and content env =
  let open Compilation_unit in
  function
  | Module m -> Module (signature env m)
  | Pack _ -> failwith "Unhandled content"

and value_ env t =
  let open Value in
  { t with doc = comment_docs env t.doc; type_ = type_expression env t.type_ }

and comment_inline_element :
    Env.t -> Comment.inline_element -> Comment.inline_element =
 fun env x ->
  match x with
  | `Styled (s, ls) ->
      `Styled (s, List.map (with_location comment_inline_element env) ls)
  | `Reference (r, []) -> (
      (* Format.fprintf Format.err_formatter "XXXXXXXXXX about to resolve reference: %a\n%!" (Component.Fmt.model_reference) r; *)
      match Ref_tools.resolve_reference env r with
      | Some (`Identifier (#Odoc_model.Paths.Identifier.Label.t as i) as r) ->
          (* Format.fprintf Format.err_formatter "XXXXXXXXXX resolved reference: %a\n%!" (Component.Fmt.model_resolved_reference) r; *)
          let content =
            match Env.lookup_section_title i env with Some x -> x | None -> []
          in
          `Reference (`Resolved r, content)
      | Some x ->
          (* Format.fprintf Format.err_formatter "XXXXXXXXXX resolved reference: %a\n%!" (Component.Fmt.model_resolved_reference) x; *)
          `Reference (`Resolved x, [])
      | None ->
          (* Format.fprintf Format.err_formatter "XXXXXXXXXX FAILED to resolve reference: %a\n%!" (Component.Fmt.model_reference) r; *)
          `Reference (r, [])
      | exception e ->
          let bt = Printexc.get_backtrace () in
          Format.fprintf Format.err_formatter
            "Caught exception while resolving reference (%a): %s\n%s\n%!"
            Component.Fmt.model_reference r (Printexc.to_string e) bt;
          `Reference (r, []) )
  | `Reference (r, content) as orig -> (
      (* Format.fprintf Format.err_formatter "XXXXXXXXXX about to resolve contentful reference: %a\n" (Component.Fmt.model_reference) r; *)
      match Ref_tools.resolve_reference env r with
      | Some x -> `Reference (`Resolved x, content)
      | None -> orig )
  | y -> y

and comment_nestable_block_element env (x : Comment.nestable_block_element) =
  match x with
  | `Paragraph elts ->
      `Paragraph (List.map (with_location comment_inline_element env) elts)
  | (`Code_block _ | `Verbatim _) as x -> x
  | `List (x, ys) ->
      `List
        ( x,
          List.map
            (List.map (with_location comment_nestable_block_element env))
            ys )
  | x -> x

and comment_block_element env (x : Comment.block_element) =
  match x with
  | #Comment.nestable_block_element as x ->
      (comment_nestable_block_element env x :> Comment.block_element)
  | `Heading _ as x -> x
  | `Tag _ as x -> x

and with_location :
    type a.
    (Env.t -> a -> a) ->
    Env.t ->
    a Location_.with_location ->
    a Location_.with_location =
 fun fn env x -> { x with Location_.value = fn env x.Location_.value }

and comment_docs env d = List.map (with_location comment_block_element env) d

and comment env = function
  | `Stop -> `Stop
  | `Docs d -> `Docs (comment_docs env d)

and exception_ env e =
  let open Exception in
  let res = Opt.map (type_expression env) e.res in
  let args = type_decl_constructor_argument env e.args in
  let doc = comment_docs env e.doc in
  { e with res; args; doc }

and extension env t =
  let open Extension in
  let constructor c =
    let open Constructor in
    {
      c with
      args = type_decl_constructor_argument env c.args;
      res = Opt.map (type_expression env) c.res;
      doc = comment_docs env c.doc;
    }
  in
  let type_path = type_path env t.type_path in
  let constructors = List.map constructor t.constructors in
  let doc = comment_docs env t.doc in
  { t with type_path; constructors; doc }

and external_ env e =
  let open External in
  { e with type_ = type_expression env e.type_; doc = comment_docs env e.doc }

and class_type_expr env =
  let open ClassType in
  function
  | Constr (path, texps) -> Constr (path, List.map (type_expression env) texps)
  | Signature s -> Signature (class_signature env s)

and class_type env c =
  let open ClassType in
  let doc = comment_docs env c.doc in
  { c with expr = class_type_expr env c.expr; doc }

and class_signature env c =
  let open ClassSignature in
  let env = Env.open_class_signature c env in
  let map_item = function
    | Method m -> Method (method_ env m)
    | InstanceVariable i -> InstanceVariable (instance_variable env i)
    | Constraint (t1, t2) ->
        Constraint (type_expression env t1, type_expression env t2)
    | Inherit c -> Inherit (class_type_expr env c)
    | Comment c -> Comment c
  in
  {
    self = Opt.map (type_expression env) c.self;
    items = List.map map_item c.items;
  }

and method_ env m =
  let open Method in
  let doc = comment_docs env m.doc in
  { m with type_ = type_expression env m.type_; doc }

and instance_variable env i =
  let open InstanceVariable in
  let doc = comment_docs env i.doc in
  { i with type_ = type_expression env i.type_; doc }

and class_ env c =
  let open Class in
  let rec map_decl = function
    | ClassType expr -> ClassType (class_type_expr env expr)
    | Arrow (lbl, expr, decl) ->
        Arrow (lbl, type_expression env expr, map_decl decl)
  in
  let doc = comment_docs env c.doc in
  { c with type_ = map_decl c.type_; doc }

and module_substitution env m =
  let open ModuleSubstitution in
  let doc = comment_docs env m.doc in
  { m with manifest = module_path env m.manifest; doc }

and signature : Env.t -> Signature.t -> _ =
 fun env s ->
  let open Signature in
  (* Format.fprintf Format.err_formatter "In Resolve2.signature\n%!"; *)
  let env = Env.open_signature s env in
  List.map
    (fun item ->
      match item with
      | Module (r, m) -> Module (r, module_ env m)
      | ModuleSubstitution m -> ModuleSubstitution (module_substitution env m)
      | Type (r, t) -> Type (r, type_decl env t)
      | TypeSubstitution t -> TypeSubstitution (type_decl env t)
      | ModuleType mt -> ModuleType (module_type env mt)
      | Value v -> Value (value_ env v)
      | Comment c -> Comment (comment env c)
      | TypExt t -> TypExt (extension env t)
      | Exception e -> Exception (exception_ env e)
      | External e -> External (external_ env e)
      | Class (r, c) -> Class (r, class_ env c)
      | ClassType (r, c) -> ClassType (r, class_type env c)
      | Include i -> Include (include_ env i))
    s

and module_expansion : Env.t -> Module.expansion -> Module.expansion =
 fun env m ->
  let open Module in
  match m with
  | AlreadyASig -> AlreadyASig
  | Signature sg -> Signature (signature env sg)
  | Functor (args, sg) ->
      let env' =
        List.fold_right
          (fun arg_opt env ->
            match arg_opt with
            | None -> env
            | Some arg ->
                let identifier = arg.FunctorArgument.id in
                let env' =
                  Env.add_module identifier
                    (Component.module_of_functor_argument
                       (Component.Of_Lang.functor_argument
                          Component.Of_Lang.empty
                          (Ident.Of_Identifier.module_ arg.id)
                          arg))
                    env
                in
                env')
          args env
      in
      Functor (List.map (functor_argument_opt env') args, signature env' sg)

and module_ : Env.t -> Module.t -> Module.t =
 fun env m ->
  let open Module in
  try
    let env = Env.add_functor_args (m.id :> Paths.Identifier.Signature.t) env in
    let type_ =
      module_decl env (m.id :> Paths.Identifier.Signature.t) m.type_
    in
    let hidden_alias =
      match type_ with
      | Alias p when Paths.Path.is_hidden (p :> Paths.Path.t) -> true
      | _ -> false
    in
    let self_canonical =
      match type_ with
      | Alias (`Resolved p) -> (
          match Paths.Path.Resolved.Module.canonical_ident p with
          | Some i -> i = m.id (* Self-canonical *)
          | None -> false )
      | _ -> false
    in
    let moduletype_expansion =
      match type_ with
      | Alias _ -> false
      | ModuleType (Signature _) -> false
      | _ -> true
    in
    let expansion_needed =
      moduletype_expansion || (self_canonical || hidden_alias)
    in
    let env, expansion =
      match (m.expansion, expansion_needed) with
      | None, true ->
          let m' = Env.lookup_module m.id env in
          let env, expansion =
            try
              let env, e = Expand_tools.expansion_of_module env m.id m' in
              (env, Some e)
            with Tools.OpaqueModule -> (env, None)
          in
          (env, expansion)
      | _ -> (env, m.expansion)
    in
    let doc, expansion =
      match m.doc with
      | (_::_) -> m.doc, expansion
      | [] ->
        match expansion with
        | Some (Signature (Comment (`Docs _doc) :: Comment (`Docs d2) :: expansion))
          -> d2, Some (Signature (expansion))
        | _ -> [], expansion
    in
    let override_display_type =
      (self_canonical || hidden_alias || not (moduletype_expansion))
    in
    let display_type =
      match override_display_type, expansion with
      | true, Some (Signature sg) -> Some (ModuleType (Signature sg))
      | _ -> None
    in
    {
      m with
      doc = comment_docs env doc;
      type_ = module_decl env (m.id :> Paths.Identifier.Signature.t) m.type_;
      display_type;
      expansion = Opt.map (module_expansion env) expansion;
    }
  with
  | Component_find.Find_failure (sg, name, ty) as e ->
      let bt = Printexc.get_backtrace () in
      Format.fprintf Format.err_formatter
        "Find failure: Failed to find %s %s in %a\n" ty name
        Component.Fmt.signature sg;
      Printf.fprintf stderr "Backtrace: %s\n%!" bt;
      raise e
  | Env.MyFailure (x, _) as e ->
      Format.fprintf Format.err_formatter
        "Failed to expand module: looking up identifier %a while expanding \
         module %a\n\
         %!"
        Component.Fmt.model_identifier x Component.Fmt.model_identifier
        (m.id :> Paths.Identifier.t);
      raise e
  | e ->
      Printf.fprintf stderr "Failed to resolve module: %s\n%s\n%!"
        (Printexc.to_string e)
        (Printexc.get_backtrace ());
      raise e

and module_decl :
    Env.t -> Paths.Identifier.Signature.t -> Module.decl -> Module.decl =
 fun env id decl ->
  let open Module in
  match decl with
  | ModuleType expr -> ModuleType (module_type_expr env id expr)
  | Alias p -> Alias (module_path env p)

and module_type : Env.t -> ModuleType.t -> ModuleType.t =
 fun env m ->
  let open ModuleType in
  try
    let env' =
      Env.add_functor_args (m.id :> Paths.Identifier.Signature.t) env
    in
    let expr' =
      match m.expr with
      | None -> None
      | Some expr ->
          Some
            (module_type_expr env' (m.id :> Paths.Identifier.Signature.t) expr)
    in
(*    let self_canonical =
      match m.expr with
      | Some (Path (`Resolved p)) when Paths.Path.Resolved.ModuleType.canonical_ident p = Some m.id ->
        true
      | _ -> false
    in*)
    let display_expr =
      match expr', m.expansion with
      | Some (Path (`Resolved p)), Some (Signature sg) when Paths.Path.Resolved.ModuleType.is_hidden p -> Some (Some (Signature sg))
      | _ -> None
    in
    let doc = comment_docs env m.doc in
    {
      m with
      expr = expr';
      expansion = Opt.map (module_expansion env') m.expansion;
      display_expr;
      doc;
    }
  with e ->
    Format.fprintf Format.err_formatter "Failed to resolve module_type (%a): %s"
      Component.Fmt.model_identifier
      (m.id :> Paths.Identifier.t)
      (Printexc.to_string e);
    raise e

and include_ : Env.t -> Include.t -> Include.t =
 fun env i ->
  let open Include in
  try
    {
      i with
      decl = module_decl env i.parent i.decl;
      expansion =
        { resolved = true; content = signature env i.expansion.content };
      doc = comment_docs env i.doc;
    }
  with Env.MyFailure (_id, _env) as e ->
    (* Format.fprintf Format.err_formatter
         "Failed to find module:\nIdentifier: %a\n\n"
         Component.Fmt.model_identifier
         (id :> Odoc_model.Paths.Identifier.t);
       List.iter
         (fun (ident, _) ->
           Format.fprintf Format.err_formatter "%a;\n"
             Component.Fmt.model_identifier
             (ident :> Odoc_model.Paths.Identifier.t))
         (Env.modules_of env);

           let i' = Component.Of_Lang.(module_decl empty i.decl) in
           Format.fprintf Format.err_formatter
             "Failed to resolve include: %a\nGot exception %s (parent=%a)\n%!"
             Component.Fmt.module_decl i' (Printexc.to_string e)
             Component.Fmt.model_identifier
             (i.parent :> Paths.Identifier.t);*)
    raise e

and functor_argument : Env.t -> FunctorArgument.t -> FunctorArgument.t =
 fun env a ->
  let functor_arg = Env.lookup_module a.id env in
  let env, expn =
    match (a.expansion, functor_arg.type_) with
    | None, ModuleType expr -> (
        try
          let env, e =
            Expand_tools.expansion_of_module_type_expr env
              (a.id :> Paths_types.Identifier.signature)
              expr
          in
          (env, Some e)
        with Tools.OpaqueModule -> (env, None) )
    | x, _ -> (env, x)
  in
  {
    a with
    expr = module_type_expr env (a.id :> Paths.Identifier.Signature.t) a.expr;
    expansion = Opt.map (module_expansion env) expn;
  }

and functor_argument_opt env a = Component.Opt.map (functor_argument env) a

and module_type_expr :
    Env.t -> Paths.Identifier.Signature.t -> ModuleType.expr -> ModuleType.expr
    =
 fun env id expr ->
  let open ModuleType in
  match expr with
  | Signature s -> Signature (signature env s)
  | Path p -> Path (module_type_path env p)
  | With (expr, subs) ->
      let cexpr = Component.Of_Lang.(module_type_expr empty expr) in
      let sg = Tools.signature_of_module_type_expr_nopath env cexpr in
      (* Format.fprintf Format.err_formatter
         "Handling `With` expression for %a (expr=%a) [%a]\n%!"
         Component.Fmt.model_identifier
         (id :> Paths.Identifier.t)
         Component.Fmt.module_type_expr cexpr Component.Fmt.substitution_list
         (List.map Component.Of_Lang.(module_type_substitution empty) subs);*)
      With
        ( module_type_expr env id expr,
          List.fold_left
            (fun (sg, subs) sub ->
              try
                (* Format.fprintf Format.err_formatter "Signature is: %a\n%!"
                   Component.Fmt.signature sg; *)
                (* Format.fprintf Format.err_formatter "Handling sub: %a\n%!"
                   Component.Fmt.substitution
                   Component.Of_Lang.(module_type_substitution empty sub); *)
                match sub with
                | ModuleEq (frag, decl) ->
                    let frag' =
                      Tools.resolve_mt_module_fragment env (id, sg) frag
                    in
                    let sg' =
                      Tools.fragmap_module env frag
                        Component.Of_Lang.(module_type_substitution empty sub)
                        sg
                    in
                    ( sg',
                      ModuleEq (`Resolved frag', module_decl env id decl)
                      :: subs )
                | TypeEq (frag, eqn) ->
                    let frag' =
                      Tools.resolve_mt_type_fragment env (id, sg) frag
                    in
                    let sg' =
                      Tools.fragmap_type env frag
                        Component.Of_Lang.(module_type_substitution empty sub)
                        sg
                    in
                    ( sg',
                      TypeEq (`Resolved frag', type_decl_equation env eqn)
                      :: subs )
                | ModuleSubst (frag, mpath) ->
                    let frag' =
                      Tools.resolve_mt_module_fragment env (id, sg) frag
                    in
                    let sg' =
                      Tools.fragmap_module env frag
                        Component.Of_Lang.(module_type_substitution empty sub)
                        sg
                    in
                    ( sg',
                      ModuleSubst (`Resolved frag', module_path env mpath)
                      :: subs )
                | TypeSubst (frag, eqn) ->
                    let frag' =
                      Tools.resolve_mt_type_fragment env (id, sg) frag
                    in
                    let sg' =
                      Tools.fragmap_type env frag
                        Component.Of_Lang.(module_type_substitution empty sub)
                        sg
                    in
                    ( sg',
                      TypeSubst (`Resolved frag', type_decl_equation env eqn)
                      :: subs )
              with e ->
                let bt = Printexc.get_backtrace () in
                Printf.fprintf stderr
                  "Exception caught while resolving fragments: %s\n%s\n%!"
                  (Printexc.to_string e) bt;
                raise e)
            (sg, []) subs
          |> snd |> List.rev)
  | Functor (arg, res) ->
      let arg' = Opt.map (functor_argument env) arg in
      let res' = module_type_expr env id res in
      Functor (arg', res')
  | TypeOf decl -> TypeOf (module_decl env id decl)

and type_decl_representation :
    Env.t -> TypeDecl.Representation.t -> TypeDecl.Representation.t =
 fun env r ->
  let open TypeDecl.Representation in
  match r with
  | Variant cs -> Variant (List.map (type_decl_constructor env) cs)
  | Record fs -> Record (List.map (type_decl_field env) fs)
  | Extensible -> Extensible

and type_decl : Env.t -> TypeDecl.t -> TypeDecl.t =
 fun env t ->
  let open TypeDecl in
  try
    let equation = type_decl_equation env t.equation in
    let doc = comment_docs env t.doc in
    let hidden_path = match equation.Equation.manifest with
      | Some (Constr (`Resolved path,_)) when Paths.Path.Resolved.Type.is_hidden path -> Some path
      | _ -> None
    in
    let representation =
      Opt.map (type_decl_representation env) t.representation
    in
    let default = { t with equation; doc; representation } in

    match hidden_path with
    | Some p -> (
      let p' = Component.Of_Lang.resolved_type_path Component.Of_Lang.empty p in
      match Tools.lookup_type_from_resolved_path env p' with
      | (_, Found (`T t')) ->
        (* Format.fprintf Format.err_formatter "XXXXXXX - replacing type at id %a maybe: %a\n%!" Component.Fmt.model_identifier (t.id :> Paths.Identifier.t) Component.Fmt.resolved_type_path p'; *)
        { default with equation = Lang_of.type_decl_equation Lang_of.empty t'.equation }
      | _ -> default)
    | None -> default
  with e ->
    Format.fprintf Format.err_formatter "Failed to resolve type (%a): %s"
      Component.Fmt.model_identifier
      (t.id :> Paths.Identifier.t)
      (Printexc.to_string e);
    raise e

and type_decl_equation env t =
  let open TypeDecl.Equation in
  let manifest = Opt.map (type_expression env) t.manifest in
  let constraints =
    List.map
      (fun (tex1, tex2) -> (type_expression env tex1, type_expression env tex2))
      t.constraints
  in
  { t with manifest; constraints }

and type_decl_field env f =
  let open TypeDecl.Field in
  let doc = comment_docs env f.doc in
  { f with type_ = type_expression env f.type_; doc }

and type_decl_constructor_argument env c =
  let open TypeDecl.Constructor in
  match c with
  | Tuple ts -> Tuple (List.map (type_expression env) ts)
  | Record fs -> Record (List.map (type_decl_field env) fs)

and type_decl_constructor env c =
  let open TypeDecl.Constructor in
  let doc = comment_docs env c.doc in
  let args = type_decl_constructor_argument env c.args in
  let res = Opt.map (type_expression env) c.res in
  { c with doc; args; res }

and type_expression_polyvar env v =
  let open TypeExpr.Polymorphic_variant in
  let constructor c =
    let open Constructor in
    let doc = comment_docs env c.doc in
    { c with arguments = List.map (type_expression env) c.arguments; doc }
  in
  let element = function
    | Type t -> Type (type_expression env t)
    | Constructor c -> Constructor (constructor c)
  in
  { v with elements = List.map element v.elements }

and type_expression_object env o =
  let open TypeExpr.Object in
  let method_ m = { m with type_ = type_expression env m.type_ } in
  let field = function
    | Method m -> Method (method_ m)
    | Inherit t -> Inherit (type_expression env t)
  in
  { o with fields = List.map field o.fields }

and type_expression_package env p =
  let open TypeExpr.Package in
  let cp = Component.Of_Lang.(module_type_path empty p.path) in
  match Tools.lookup_and_resolve_module_type_from_path true env cp with
  | Resolved (path, mt) ->
      let sg = Tools.signature_of_module_type_nopath env mt in
      let path = Cpath.resolved_module_type_path_of_cpath path in
      let identifier =
        ( Paths.Path.Resolved.ModuleType.identifier path
          :> Paths.Identifier.Signature.t )
      in
      let substitution (frag, t) =
        let frag' = Tools.resolve_mt_type_fragment env (identifier, sg) frag in
        (`Resolved frag', type_expression env t)
      in
      {
        path = module_type_path env p.path;
        substitutions = List.map substitution p.substitutions;
      }
  | Unresolved p' -> { p with path = Cpath.module_type_path_of_cpath p' }

and type_expression : Env.t -> _ -> _ =
 fun env texpr ->
  let open TypeExpr in
  try
    match texpr with
    | Var _ | Any -> texpr
    | Alias (t, str) -> Alias (type_expression env t, str)
    | Arrow (lbl, t1, t2) ->
        Arrow (lbl, type_expression env t1, type_expression env t2)
    | Tuple ts -> Tuple (List.map (type_expression env) ts)
    | Constr (path, ts) -> (
        let cp = Component.Of_Lang.(type_path empty path) in
        match Tools.lookup_type_from_path env cp with
        | Resolved (cp', Found (`T t)) -> begin
            let p = Cpath.resolved_type_path_of_cpath cp' in
            if Cpath.is_resolved_type_hidden cp'
            then match t.Component.TypeDecl.equation.Component.TypeDecl.Equation.manifest with
            | Some expr ->
              (* Format.fprintf Format.err_formatter "Here we go...%a \n" Component.Fmt.type_path cp; *)
              type_expression env (Lang_of.(type_expr empty expr))
            | None -> 
                Constr (`Resolved p, ts)
            else Constr (`Resolved p, ts)
            end
        | Resolved (cp', Found _) ->
          let p = Cpath.resolved_type_path_of_cpath cp' in
          Constr (`Resolved p, ts)
        | Resolved (_cp, Replaced x) -> Lang_of.(type_expr empty x)
        | Unresolved p -> Constr (Cpath.type_path_of_cpath p, ts) )
    | Polymorphic_variant v ->
        Polymorphic_variant (type_expression_polyvar env v)
    | Object o -> Object (type_expression_object env o)
    | Class (path, ts) -> Class (path, List.map (type_expression env) ts)
    | Poly (strs, t) -> Poly (strs, type_expression env t)
    | Package p -> Package (type_expression_package env p)
  with _ -> texpr

(*
let build_resolver :
    ?equal:(Root.t -> Root.t -> bool) ->
    ?hash:(Root.t -> int) ->
    (string -> Env.lookup_unit_result) ->
    (Root.t -> Compilation_unit.t) ->
    (string -> Root.t option) ->
    (Root.t -> Page.t) ->
    Env.resolver =
 fun ?equal:_ ?hash:_ lookup_unit resolve_unit lookup_page resolve_page ->
  { Env.lookup_unit; resolve_unit; lookup_page; resolve_page }
*)
let link x y =
  let before = y in
  let after = unit x before in
  after

let resolve_page resolver y =
  let env = Env.set_resolver Env.empty resolver in
  {
    y with
    Page.content =
      List.map (with_location comment_block_element env) y.Page.content;
  }
