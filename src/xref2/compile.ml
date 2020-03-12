(* Phase 1 - compilation *)

(* First round of resolving only attempts to resolve paths and fragments, and then only those
   that don't contain forward paths *)

open Odoc_model
open Lang

module Opt = struct
  let map f = function Some x -> Some (f x) | None -> None
end

let type_path : Env.t -> Paths.Path.Type.t -> Paths.Path.Type.t =
 fun env p ->
  let cp = Component.Of_Lang.(type_path empty p) in
  match Tools.lookup_type_from_path env cp with
  | Resolved (p', _) -> `Resolved (Cpath.resolved_type_path_of_cpath p')
  | Unresolved p -> Cpath.type_path_of_cpath p
  | exception _ ->
      Lookup_failures.report "Failed to lookup type path %a"
        Component.Fmt.model_path
        (p :> Paths.Path.t);
      p

and module_type_path :
    Env.t -> Paths.Path.ModuleType.t -> Paths.Path.ModuleType.t =
 fun env p ->
  let cp = Component.Of_Lang.(module_type_path empty p) in
  match Tools.lookup_and_resolve_module_type_from_path true env cp with
  | Resolved (p', _) -> `Resolved (Cpath.resolved_module_type_path_of_cpath p')
  | Unresolved p -> Cpath.module_type_path_of_cpath p
  | exception _ ->
      Lookup_failures.report "Failed to lookup module_type path %a"
        Component.Fmt.model_path
        (p :> Paths.Path.t);
      p

and module_path : Env.t -> Paths.Path.Module.t -> Paths.Path.Module.t =
 fun env p ->
  let cp = Component.Of_Lang.(module_path empty p) in
  match Tools.lookup_and_resolve_module_from_path true true env cp with
  | Resolved (p', _) -> `Resolved (Cpath.resolved_module_path_of_cpath p')
  | Unresolved p -> Cpath.module_path_of_cpath p
  | exception _ ->
      Lookup_failures.report "Failed to lookup module path %a"
        Component.Fmt.model_path
        (p :> Paths.Path.t);
      p

let rec unit (resolver : Env.resolver) t =
  let open Compilation_unit in
  let imports, env = Env.initial_env t resolver in
  { t with content = content env t.content; imports }

and content env =
  let open Compilation_unit in
  function
  | Module m -> Module (signature env m)
  | Pack _ -> failwith "Unhandled content"

and value_ env t =
  let open Value in
  try { t with type_ = type_expression env t.type_ }
  with e ->
    Lookup_failures.report_important e "%a" Component.Fmt.model_identifier
      (t.id :> Paths.Identifier.t);
    t

and exception_ env e =
  let open Exception in
  let res = Opt.map (type_expression env) e.res in
  let args = type_decl_constructor_argument env e.args in
  { e with res; args }

and extension env t =
  let open Extension in
  let constructor c =
    let open Constructor in
    {
      c with
      args = type_decl_constructor_argument env c.args;
      res = Opt.map (type_expression env) c.res;
    }
  in
  let type_path = type_path env t.type_path in
  let constructors = List.map constructor t.constructors in
  { t with type_path; constructors }

and external_ env e =
  let open External in
  { e with type_ = type_expression env e.type_ }

and class_type_expr env =
  let open ClassType in
  function
  | Constr (path, texps) -> Constr (path, List.map (type_expression env) texps)
  | Signature s -> Signature (class_signature env s)

and class_type env c =
  let open ClassType in
  let c' = Env.lookup_class_type c.id env in
  let _p, sg =
    Tools.class_signature_of_class_type env
      (`Identifier (c.id :> Paths_types.Identifier.path_class_type), c')
  in
  let expansion =
    Some
      (Lang_of.class_signature Lang_of.empty
         (c.id :> Paths_types.Identifier.path_class_type)
         sg)
  in

  { c with expr = class_type_expr env c.expr; expansion }

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
  { m with type_ = type_expression env m.type_ }

and instance_variable env i =
  let open InstanceVariable in
  { i with type_ = type_expression env i.type_ }

and class_ env c =
  let open Class in
  let c' = Env.lookup_class c.id env in
  let _p, sg =
    Tools.class_signature_of_class env
      (`Identifier (c.id :> Paths_types.Identifier.path_class_type), c')
  in
  let expansion =
    Some
      (Lang_of.class_signature Lang_of.empty
         (c.id :> Paths_types.Identifier.path_class_type)
         sg)
  in

  let rec map_decl = function
    | ClassType expr -> ClassType (class_type_expr env expr)
    | Arrow (lbl, expr, decl) ->
        Arrow (lbl, type_expression env expr, map_decl decl)
  in
  { c with type_ = map_decl c.type_; expansion }

and module_substitution env m =
  let open ModuleSubstitution in
  { m with manifest = module_path env m.manifest }

and signature_items : Env.t -> Signature.t -> _ =
 fun env s ->
  let open Signature in
  List.map
    (fun item ->
      match item with
      | Module (r, m) -> Module (r, module_ env m)
      | ModuleSubstitution m -> ModuleSubstitution (module_substitution env m)
      | Type (r, t) -> Type (r, type_decl env t)
      | TypeSubstitution t -> TypeSubstitution (type_decl env t)
      | ModuleType mt -> ModuleType (module_type env mt)
      | Value v -> Value (value_ env v)
      | Comment c -> Comment c
      | TypExt t -> TypExt (extension env t)
      | Exception e -> Exception (exception_ env e)
      | External e -> External (external_ env e)
      | Class (r, c) -> Class (r, class_ env c)
      | ClassType (r, c) -> ClassType (r, class_type env c)
      | Include i -> Include (include_ env i))
    s

and signature : Env.t -> Signature.t -> _ =
 fun env s ->
  let env = Env.open_signature s env in
  signature_items env s

and module_ : Env.t -> Module.t -> Module.t =
 fun env m ->
  let open Module in
  let extra_expansion_needed =
    match m.type_ with
    | ModuleType (Signature _) -> false (* AlreadyASig *)
    | ModuleType _ -> true
    | Alias _ -> false
  in
  let env' = Env.add_functor_args (m.id :> Paths.Identifier.Signature.t) env in
  let expansion =
    if not extra_expansion_needed then m.expansion
    else
      let m' = Env.lookup_module m.id env in
      try
        let env, e = Expand_tools.expansion_of_module env m.id m' in
        Some (expansion env e)
      with
      | Tools.OpaqueModule -> None
      | Tools.UnresolvedForwardPath -> None
      | Tools.UnresolvedPath (`Module p) as e ->
          Lookup_failures.report_important e "Failed to expand module id %a (failed to resolve %a)"
            Component.Fmt.model_identifier
            (m.id :> Odoc_model.Paths.Identifier.t)
            Component.Fmt.module_path
            p;
          m.expansion
  in
  try
    {
      m with
      type_ = module_decl env' (m.id :> Paths.Identifier.Signature.t) m.type_;
      expansion;
    }
  with
  | Find.Find_failure (sg, name, ty) as e ->
      Lookup_failures.report_important e
        "Find failure: Failed to find %s %s in %a" ty name
        Component.Fmt.signature sg;
      m
  | e ->
      Lookup_failures.report_important e "Failed to resolve module id %a"
        Component.Fmt.model_identifier
        (m.id :> Odoc_model.Paths.Identifier.t);
      m

and module_decl :
    Env.t -> Paths.Identifier.Signature.t -> Module.decl -> Module.decl =
 fun env id decl ->
  let open Module in
  match decl with
  | ModuleType expr -> ModuleType (module_type_expr env id expr)
  | Alias p -> (
      let cp = Component.Of_Lang.(module_path empty p) in
      match Tools.lookup_and_resolve_module_from_path true true env cp with
      | Resolved (p', _) ->
          Alias (`Resolved (Cpath.resolved_module_path_of_cpath p'))
      | Unresolved p' -> Alias (Cpath.module_path_of_cpath p') )

and module_type : Env.t -> ModuleType.t -> ModuleType.t =
 fun env m ->
  let open ModuleType in
  try
    let env = Env.add_functor_args (m.id :> Paths.Identifier.Signature.t) env in
    let expansion, expr' =
      match m.expr with
      | None -> (None, None)
      | Some expr ->
          let m' = Env.lookup_module_type m.id env in
          let env, expansion =
            try
              let env, e = Expand_tools.expansion_of_module_type env m.id m' in
              (env, Some e)
            with
            | Tools.OpaqueModule -> (env, None)
            | e ->
                Lookup_failures.report_important e
                  "Failed to expand module_type %a"
                  Component.Fmt.model_identifier
                  (m.id :> Paths.Identifier.t);
                (env, None)
          in
          ( expansion,
            Some
              (module_type_expr env (m.id :> Paths.Identifier.Signature.t) expr)
          )
    in
    { m with expr = expr'; expansion }
  with e ->
    Lookup_failures.report_important e "Failed to resolve module_type %a"
      Component.Fmt.model_identifier
      (m.id :> Paths.Identifier.t);
    m

and include_ : Env.t -> Include.t -> Include.t =
 fun env i ->
  let open Include in
  try
    let remove_top_doc_from_signature =
      let open Signature in
      function Comment (`Docs _) :: xs -> xs | xs -> xs
    in
    let decl = Component.Of_Lang.(module_decl empty i.decl) in
    let _, expn =
      Expand_tools.aux_expansion_of_module_decl env decl
      |> Expand_tools.handle_expansion env i.parent
    in
    let expansion =
      (* try ( *)
      match expn with
      | Module.Signature sg ->
          {
            resolved = true;
            content = remove_top_doc_from_signature (signature env sg);
          }
      | _ -> i.expansion
      (* ) with _ -> i.expansion *)
    in
    { i with decl = module_decl env i.parent i.decl; expansion }
  with e ->
    let i' = Component.Of_Lang.(module_decl empty i.decl) in
    Lookup_failures.report_important e
      "Failed to resolve include %a (parent: %a)" Component.Fmt.module_decl i'
      Component.Fmt.model_identifier
      (i.parent :> Paths.Identifier.t);
    i

and expansion : Env.t -> Module.expansion -> Module.expansion =
  let open Module in
  fun env e ->
    match e with
    | AlreadyASig -> AlreadyASig
    | Signature sg -> Signature (signature env sg)
    | Functor (args, sg) ->
        Functor (List.map (functor_argument_opt env) args, signature env sg)

and functor_argument_opt :
    Env.t -> FunctorArgument.t option -> FunctorArgument.t option =
 fun env arg_opt -> Component.Opt.map (functor_argument env) arg_opt

and functor_argument : Env.t -> FunctorArgument.t -> FunctorArgument.t =
 fun env a ->
  let functor_arg = Env.lookup_module a.id env in
  let env, expn =
    match functor_arg.type_ with
    | ModuleType expr -> (
        try
          let env, e =
            Expand_tools.expansion_of_module_type_expr env
              (a.id :> Paths_types.Identifier.signature)
              expr
          in
          (env, Some e)
        with Tools.OpaqueModule -> (env, None) )
    | _ -> failwith "error"
  in
  {
    a with
    expr = module_type_expr env (a.id :> Paths.Identifier.Signature.t) a.expr;
    expansion = Component.Opt.map (expansion env) expn;
  }

and module_type_expr :
    Env.t -> Paths.Identifier.Signature.t -> ModuleType.expr -> ModuleType.expr
    =
 fun env id expr ->
  let open ModuleType in
  let rec inner resolve_signatures = 
    function
    | Signature s -> 
      if resolve_signatures
      then Signature (signature env s)
      else Signature s
  | Path p -> Path (module_type_path env p)
  | With (expr, subs) ->
      let cexpr = Component.Of_Lang.(module_type_expr empty expr) in
      let sg = Tools.signature_of_module_type_expr_nopath env cexpr in
      (* Format.fprintf Format.err_formatter
         "Handling `With` expression for %a [%a]\n%!"
         Component.Fmt.model_identifier
         (id :> Paths.Identifier.t)
         Component.Fmt.substitution_list
         (List.map Component.Of_Lang.(module_type_substitution empty) subs);*)
      With
        ( inner false expr,
          List.fold_left
            (fun (sg, subs) sub ->
              try
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
                Lookup_failures.report_important e
                  "Exception caught while resolving fragments %a"
                  Component.Fmt.substitution
                  Component.Of_Lang.(module_type_substitution empty sub);
                ( sg, sub :: subs ))
            (sg, []) subs
          |> snd |> List.rev )
  | Functor (arg, res) ->
      let arg' = Opt.map (functor_argument env) arg in
      let res' = module_type_expr env id res in
      Functor (arg', res')
  | TypeOf (ModuleType expr) -> TypeOf (ModuleType (inner resolve_signatures expr))
  | TypeOf (Alias p) -> TypeOf (Alias (module_path env p))
  in inner true expr

and type_decl : Env.t -> TypeDecl.t -> TypeDecl.t =
 fun env t ->
  let open TypeDecl in
  try
    let equation = type_decl_equation env t.equation in
    { t with equation }
  with e ->
    Lookup_failures.report_important e "Failed to resolve type %a"
      Component.Fmt.model_identifier
      (t.id :> Paths.Identifier.t);
    t

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
  { f with type_ = type_expression env f.type_ }

and type_decl_constructor_argument env c =
  let open TypeDecl.Constructor in
  match c with
  | Tuple ts -> Tuple (List.map (type_expression env) ts)
  | Record fs -> Record (List.map (type_decl_field env) fs)

and type_expression_polyvar env v =
  let open TypeExpr.Polymorphic_variant in
  let constructor c =
    let open Constructor in
    { c with arguments = List.map (type_expression env) c.arguments }
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
  match texpr with
  | Var _ | Any -> texpr
  | Alias (t, str) -> Alias (type_expression env t, str)
  | Arrow (lbl, t1, t2) ->
      Arrow (lbl, type_expression env t1, type_expression env t2)
  | Tuple ts -> Tuple (List.map (type_expression env) ts)
  | Constr (path, ts) -> (
      let cp = Component.Of_Lang.(type_path empty path) in
      match Tools.lookup_type_from_path env cp with
      | Resolved (cp, Found _t) ->
          let p = Cpath.resolved_type_path_of_cpath cp in
          Constr (`Resolved p, ts)
      | Resolved (_cp, Replaced x) -> Lang_of.(type_expr empty x)
      | Unresolved p -> Constr (Cpath.type_path_of_cpath p, ts)
      | exception e ->
          Lookup_failures.report_important e
            "Exception handling type expression %a" Component.Fmt.type_expr
            Component.Of_Lang.(type_expression empty texpr);
          texpr )
  | Polymorphic_variant v -> Polymorphic_variant (type_expression_polyvar env v)
  | Object o -> Object (type_expression_object env o)
  | Class (path, ts) -> Class (path, List.map (type_expression env) ts)
  | Poly (strs, t) -> Poly (strs, type_expression env t)
  | Package p -> Package (type_expression_package env p)

let build_resolver :
    ?equal:(Root.t -> Root.t -> bool) ->
    ?hash:(Root.t -> int) ->
    string list ->
    (string -> Env.lookup_unit_result) ->
    (Root.t -> Compilation_unit.t) ->
    (string -> Root.t option) ->
    (Root.t -> Page.t) ->
    Env.resolver =
 fun ?equal:_ ?hash:_ open_units lookup_unit resolve_unit lookup_page
     resolve_page ->
  { Env.lookup_unit; resolve_unit; lookup_page; resolve_page; open_units }

let compile x y = Lookup_failures.catch_failures (fun () -> unit x y)

let resolve_page _resolver y = y
