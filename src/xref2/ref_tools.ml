open Odoc_model.Paths
open Reference

type module_lookup_result = Resolved.Module.t * Component.Module.t

type module_type_lookup_result = Resolved.ModuleType.t * Component.ModuleType.t

type signature_lookup_result =
  Resolved.Signature.t * Env.t * Component.Signature.t

type type_lookup_result =
  Resolved.Type.t
  * [ `T of Component.TypeDecl.t
    | `C of Component.Class.t
    | `CT of Component.ClassType.t ]

type value_lookup_result =
  Resolved.Value.t * [ `V of Component.Value.t | `E of Component.External.t ]

type label_parent_lookup_result =
  Resolved.LabelParent.t
  * Env.t
  * [ `S of Component.Signature.t | `CS of Component.ClassSignature.t | `Page of (string * Identifier.Label.t) list ]

let rec make_prefix : Resolved.Signature.t -> Cpath.resolved_module option =
  let open Tools.OptionMonad in
  function
  | `Module (parent, name) ->
      make_prefix parent >>= fun p -> return (`Module (p, name))
  | `Identifier (#Identifier.Module.t as i) -> return (`Identifier i)
  | `Canonical (m, _r) -> make_prefix (m :> Resolved.Signature.t)
  | `SubstAlias (_, r) -> make_prefix (r :> Resolved.Signature.t)
  | `Identifier _ | `ModuleType _ -> None

let prefix_signature r s =
  match make_prefix r with
  | Some prefix ->
      (* Format.fprintf Format.err_formatter
         "Prefixing with Cpath.resolved_module: %a\n%!"
         Component.Fmt.resolved_module_path prefix;*)
      Tools.prefix_signature (prefix, s) |> snd
  | None ->
      let identifier = Resolved.Signature.identifier r in
      (* Format.fprintf Format.err_formatter "Prefixing with Identifier: %a\n%!"
         Component.Fmt.model_identifier
         (identifier :> Identifier.t);*)
      Tools.prefix_ident_signature (identifier, s) |> snd

let rec choose l =
  match l with
  | [] -> None
  | x :: rest -> ( match x () with Some _ as x -> x | None -> choose rest )

let signature_lookup_result_of_label_parent :
    label_parent_lookup_result -> signature_lookup_result option =
 fun (rr, env, c) ->
  match (rr, c) with
  | (`Identifier #Odoc_model.Paths.Identifier.Signature.t as rr'), `S s ->
      Some (rr', env, s)
  | ((`SubstAlias _ | `Module _ | `Canonical _ | `ModuleType _) as rr'), `S s ->
      Some (rr', env, s)
  | _ -> None

module Hashable = struct
  type t = bool * Resolved.Signature.t

  let equal = Stdlib.( = )

  let hash = Hashtbl.hash
end

module Memos1 = Hashtbl.Make (Hashable)

(*  let memo = Memos1.create 91*)

module Hashable2 = struct
  type t = bool * Signature.t

  let equal = Stdlib.( = )

  let hash = Hashtbl.hash
end

module Memos2 = Hashtbl.Make (Hashable2)

let memo2 = Memos2.create 91

let rec verify_resolved_signature : Env.t -> Resolved.Signature.t -> bool =
 fun env r ->
  match r with
  | `Identifier (`Root (_root, name) as i) -> (
      try
        ignore (Env.lookup_module i env);
        true
      with _ -> (
        match Env.lookup_root_module name env with
        | Some _r -> true
        | None -> false ) )
  | `Identifier (#Identifier.Module.t as i) -> (
      try
        ignore (Env.lookup_module i env);
        true
      with _ ->
        Format.fprintf Format.err_formatter "failed module lookup (%a)\n%!"
          Component.Fmt.model_identifier
          (i :> Identifier.t);
        false )
  | `Identifier (`ModuleType _ as i) -> (
      try
        ignore (Env.lookup_module_type i env);
        true
      with _ ->
        Format.fprintf Format.err_formatter "failed module type lookup\n%!";
        false )
  | `Module (p, _) -> verify_resolved_signature env p
  | `ModuleType (p, _) -> verify_resolved_signature env p
  | `Canonical (p1, p2) ->
      verify_resolved_signature env (p1 :> Resolved.Signature.t)
      && verify_signature env (p2 :> Signature.t)
  | `SubstAlias (_p1, _p2) -> false

and verify_signature : Env.t -> Signature.t -> bool =
 fun env r ->
  match r with
  | `Resolved r -> verify_resolved_signature env r
  | `Root (id, _) ->
      let exists fn =
        try
          ignore (fn id env);
          true
        with _ -> false
      in
      (* We need to check that this _wouldn't_ be resolved *)
      let result =
        (not (exists Env.lookup_module_by_name))
        && (not (exists Env.lookup_module_type_by_name))
        && not (exists Env.lookup_root_module)
      in
      if result then result
      else (
        Format.fprintf Format.err_formatter "failed root check\n";
        result )
  | `Dot (p, _) -> verify_label_parent env p
  | `Module (p, _) -> verify_signature env p
  | `ModuleType (p, _) -> verify_signature env p

and verify_label_parent : Env.t -> LabelParent.t -> bool =
 fun env r ->
  match r with
  | `Resolved r -> verify_resolved_label_parent env r
  | ( `Module _ | `ModuleType _
    | `Root (_, #Odoc_model.Paths_types.Reference.tag_module) ) as sr ->
      verify_signature env sr
  | `Dot (p, _) -> verify_label_parent env p
  | `Root _ -> true
  | `Type (p, _) | `ClassType (p, _) | `Class (p, _) -> verify_signature env p

and verify_resolved_label_parent env r =
  match r with
  | (`Module _ | `ModuleType _ | `Canonical _ | `SubstAlias _) as s ->
      verify_resolved_signature env s
  | `Identifier #Identifier.Signature.t as s -> verify_resolved_signature env s
  | `Identifier _ -> true
  | `Class (p, _) | `ClassType (p, _) | `Type (p, _) ->
      verify_resolved_signature env p

let rec resolve_type_reference : Env.t -> Type.t -> type_lookup_result option =
  let open Tools.OptionMonad in
  fun env r ->
    match r with
    | `Resolved _r -> failwith "unhandled"
    | `Root (name, _) -> (
        Env.lookup_datatype_by_name name env >>= function
        | `Type (id, t) ->
            return
              ( `Identifier
                  (id :> Odoc_model.Paths_types.Identifier.reference_type),
                `T t )
        | `Class (id, t) ->
            return
              ( `Identifier
                  (id :> Odoc_model.Paths_types.Identifier.reference_type),
                `C t )
        | `ClassType (id, t) ->
            return
              ( `Identifier
                  (id :> Odoc_model.Paths_types.Identifier.reference_type),
                `CT t ) )
    | `Dot (parent, name) ->
        resolve_label_parent_reference env parent ~add_canonical:true
        >>= signature_lookup_result_of_label_parent
        >>= fun (parent', _, sg) ->
        Component_find.opt_type_in_sig sg name >>= fun t ->
        return (`Type (parent', name), t)
    | `Class (parent, name) -> (
        resolve_signature_reference env parent ~add_canonical:true
        >>= fun (parent', _, sg) ->
        Component_find.opt_type_in_sig sg name >>= function
        | `C _ as c -> return (`Class (parent', name), c)
        | _ -> None )
    | `ClassType (parent, name) -> (
        resolve_signature_reference env parent ~add_canonical:true
        >>= fun (parent', _, sg) ->
        Component_find.opt_type_in_sig sg name >>= function
        | `CT _ as c -> return (`ClassType (parent', name), c)
        | _ -> None )
    | `Type (parent, name) -> (
        resolve_signature_reference env parent ~add_canonical:true
        >>= fun (parent', _, sg) ->
        Component_find.opt_type_in_sig sg name >>= function
        | `T _ as c -> return (`Type (parent', name), c)
        | _ -> None )

and resolve_resolved_type_reference :
    Env.t -> Resolved.Type.t -> type_lookup_result =
 fun env r ->
  match r with
  | `Identifier i -> (
      match i with
      | `Type _ as i' ->
          let t = Env.lookup_type i' env in
          (r, `T t)
      | `Class _ as i' ->
          let t = Env.lookup_class i' env in
          (r, `C t)
      | `ClassType _ as i' ->
          let t = Env.lookup_class_type i' env in
          (r, `CT t)
      | `CoreType _ -> failwith "core type" )
  | `Type (parent, name) -> (
      resolve_resolved_signature_reference env parent ~add_canonical:true
      |> fun (parent', _, sg) ->
      Component_find.type_in_sig sg name |> function
      | `T _ as c -> (`Type (parent', name), c)
      | _ -> failwith "error" )
  | `ClassType (parent, name) -> (
      resolve_resolved_signature_reference env parent ~add_canonical:true
      |> fun (parent', _, sg) ->
      Component_find.type_in_sig sg name |> function
      | `CT _ as c -> (`ClassType (parent', name), c)
      | _ -> failwith "error" )
  | `Class (parent, name) -> (
      resolve_resolved_signature_reference env parent ~add_canonical:true
      |> fun (parent', _, sg) ->
      Component_find.type_in_sig sg name |> function
      | `CT _ as c -> (`ClassType (parent', name), c)
      | _ -> failwith "error" )

and resolve_resolved_signature_reference :
    Env.t ->
    Resolved.Signature.t ->
    add_canonical:bool ->
    signature_lookup_result =
 fun env r ~add_canonical ->
  let _id = (add_canonical, Env.id env, r) in
  (* if Memos1.mem memo id then Memos1.find memo id
     else *)
  (* Format.fprintf Format.err_formatter "lookup_and_resolve_module_from_resolved_path: looking up %a\n%!" Component.Fmt.resolved_path p; *)
  let result =
    match r with
    | `Identifier i ->
        let sg =
          match i with
          | (`Module _ | `Parameter _ | `Result _ | `Root _) as i' ->
              Tools.signature_of_module_nopath env (Env.lookup_module i' env)
              |> prefix_signature (`Identifier i')
          | `ModuleType _ as i' ->
              Tools.signature_of_module_type_nopath env
                (Env.lookup_module_type i' env)
              |> prefix_signature (`Identifier i')
        in
        let env =
          Env.open_component_signature (Resolved.Signature.identifier r) sg env
        in
        (r, env, sg)
    | (`Module (_, _) | `Canonical _ | `SubstAlias (_, _)) as r' ->
        let _, m = resolve_resolved_module_reference env r' ~add_canonical in
        (r, env, Tools.signature_of_module_nopath env m |> prefix_signature r)
    | `ModuleType (_, _) as r' ->
        let _, m = resolve_resolved_module_type_reference env r' in
        ( r,
          env,
          Tools.signature_of_module_type_nopath env m |> prefix_signature r' )
  in
  (*        Memos1.add memo id result;*)
  result

and resolve_resolved_module_reference :
    Env.t -> Resolved.Module.t -> add_canonical:bool -> module_lookup_result =
 fun env r ~add_canonical ->
  match r with
  | `Identifier i ->
      let m = Env.lookup_module i env in
      let r' = if add_canonical then add_canonical_path env m r else r in
      (r', m)
  | `Module (parent, name) ->
      let _, _, sg =
        resolve_resolved_signature_reference env parent ~add_canonical
      in
      let m = Component_find.module_in_sig sg name in
      let r' = if add_canonical then add_canonical_path env m r else r in
      (r', m)
  | `Canonical (p, _) ->
      let _, m = resolve_resolved_module_reference env p ~add_canonical in
      (r, m)
  | `SubstAlias (_, p) ->
      let _, m = resolve_resolved_module_reference env p ~add_canonical in
      (r, m)

and resolve_resolved_module_type_reference :
    Env.t -> Resolved.ModuleType.t -> module_type_lookup_result =
 fun env r ->
  match r with
  | `Identifier i -> (r, Env.lookup_module_type i env)
  | `ModuleType (parent, name) ->
      let _, _, sg =
        resolve_resolved_signature_reference env parent ~add_canonical:true
      in
      (r, Component_find.module_type_in_sig sg name)

and resolve_module_reference :
    Env.t -> Module.t -> add_canonical:bool -> module_lookup_result option =
  let open Tools.OptionMonad in
  fun env r ~add_canonical ->
    match r with
    | `Resolved r ->
        Some (resolve_resolved_module_reference env r ~add_canonical)
    | `Dot (parent, name) ->
        resolve_label_parent_reference env parent ~add_canonical
        >>= signature_lookup_result_of_label_parent
        >>= fun (parent', _, sg) ->
        Component_find.opt_module_in_sig sg name >>= fun m ->
        let r' =
          if add_canonical then
            add_canonical_path env m (`Module (parent', name))
          else `Module (parent', name)
        in
        return (r', m)
    | `Module (parent, name) ->
        resolve_signature_reference env parent ~add_canonical
        >>= fun (parent', _, sg) ->
        Component_find.opt_module_in_sig sg name >>= fun m ->
        let r' =
          if add_canonical then
            add_canonical_path env m (`Module (parent', name))
          else `Module (parent', name)
        in
        return (r', m)
    | `Root (name, _) -> (
        match Env.lookup_module_by_name name env with
        | Some (`Module (id, m)) ->
            let r' =
              if add_canonical then add_canonical_path env m (`Identifier id)
              else `Identifier id
            in
            return (r', m)
        | None -> (
            let x = Env.lookup_root_module name env in
            match x with
            | Some (Env.Resolved (id, m)) ->
                let r' =
                  if add_canonical then
                    add_canonical_path env m (`Identifier id)
                  else `Identifier id
                in
                return (r', m)
            | _ -> None ) )

and resolve_module_type_reference :
    Env.t ->
    ModuleType.t ->
    add_canonical:bool ->
    module_type_lookup_result option =
  let open Tools.OptionMonad in
  fun env r ~add_canonical ->
    match r with
    | `Resolved r -> Some (resolve_resolved_module_type_reference env r)
    | `Dot (parent, name) ->
        resolve_label_parent_reference env parent ~add_canonical
        >>= signature_lookup_result_of_label_parent
        >>= fun (parent', _, sg) ->
        Component_find.opt_module_type_in_sig sg name >>= fun m ->
        return (`ModuleType (parent', name), m)
    | `ModuleType (parent, name) ->
        resolve_signature_reference env parent ~add_canonical
        >>= fun (parent', _, sg) ->
        Component_find.opt_module_type_in_sig sg name >>= fun m ->
        return (`ModuleType (parent', name), m)
    | `Root (name, _) ->
        Env.lookup_module_type_by_name name env >>= fun (`ModuleType (id, m)) ->
        return (`Identifier id, m)

and resolve_label_parent_reference :
    Env.t ->
    LabelParent.t ->
    add_canonical:bool ->
    label_parent_lookup_result option =
  let open Tools.OptionMonad in
  fun env r ~add_canonical ->
    let label_parent_res_of_sig_res :
        signature_lookup_result option -> label_parent_lookup_result option =
     fun x ->
      x >>= fun (r', env, sg) ->
      return ((r' :> Resolved.LabelParent.t), env, `S sg)
    in
    match r with
    | `Resolved _ -> failwith "unimplemented"
    | ( `Module _ | `ModuleType _
      | `Root (_, #Odoc_model.Paths_types.Reference.tag_module) ) as sr ->
        resolve_signature_reference env sr ~add_canonical
        |> label_parent_res_of_sig_res
    | `Dot (parent, name) ->
        resolve_label_parent_reference env parent ~add_canonical
        >>= signature_lookup_result_of_label_parent
        >>= fun (parent', env, sg) ->
        choose
          [
            (fun () ->
              Component_find.opt_module_in_sig sg name >>= fun m ->
              let r' =
                if add_canonical then
                  add_canonical_path env m (`Module (parent', name))
                else `Module (parent', name)
              in
              let sg =
                Tools.signature_of_module_nopath env m
                |> prefix_signature (r' :> Resolved.Signature.t)
              in
              let env =
                Env.open_component_signature
                  (Resolved.Signature.identifier (r' :> Resolved.Signature.t))
                  sg env
              in
              return ((r' :> Resolved.LabelParent.t), env, `S sg));
            (fun () ->
              Component_find.opt_module_type_in_sig sg name >>= fun m ->
              let r' = `ModuleType (parent', name) in
              let sg =
                Tools.signature_of_module_type_nopath env m
                |> prefix_signature r'
              in
              let env =
                Env.open_component_signature
                  (Resolved.Signature.identifier r')
                  sg env
              in
              return (r', env, `S sg));
          ]
    | `Root (name, _) ->
        Env.lookup_page name env >>= fun p ->
        let labels = List.fold_right
                (fun element l ->
                  match element.Odoc_model.Location_.value with
                  | `Heading (_, (`Label (_, name) as x), _nested_elements) ->
                    (name,x) :: l
                  | _ -> l) p.Odoc_model.Lang.Page.content [] in
        return ((`Identifier (p.Odoc_model.Lang.Page.name :> Identifier.LabelParent.t)), env, `Page labels)
    | _ -> None

and resolve_signature_reference :
    Env.t -> Signature.t -> add_canonical:bool -> signature_lookup_result option
    =
  let open Tools.OptionMonad in
  fun env r ~add_canonical ->
    let id = (add_canonical, r) in
    (* Format.fprintf Format.err_formatter "lookup_and_resolve_module_from_resolved_path: looking up %a\n%!" Component.Fmt.resolved_path p; *)
    let resolve () =
      (* Format.fprintf Format.err_formatter "B"; *)
      match r with
      | `Resolved r ->
          Some (resolve_resolved_signature_reference env r ~add_canonical)
      | `Root (name, _) ->
          choose
            [
              (fun () ->
                Env.lookup_module_by_name name env >>= fun (`Module (id, m)) ->
                let sg =
                  Tools.signature_of_module_nopath env m
                  |> prefix_signature
                       (`Identifier (id :> Identifier.Signature.t))
                in
                let env =
                  Env.open_component_signature
                    (id :> Identifier.Signature.t)
                    sg env
                in
                return (`Identifier (id :> Identifier.Signature.t), env, sg));
              (fun () ->
                Env.lookup_root_module name env >>= function
                | Env.Resolved (id, m) ->
                    let identifier =
                      `Identifier (id :> Identifier.Signature.t)
                    in
                    let sg =
                      Tools.signature_of_module_nopath env m
                      |> prefix_signature identifier
                    in
                    let env =
                      Env.open_component_signature
                        (id :> Identifier.Signature.t)
                        sg env
                    in
                    return (identifier, env, sg)
                | _ -> None);
              (fun () ->
                Env.lookup_module_type_by_name name env
                >>= fun (`ModuleType (id, m)) ->
                let identifier = `Identifier (id :> Identifier.Signature.t) in
                let sg =
                  Tools.signature_of_module_type_nopath env m
                  |> prefix_signature identifier
                in
                let env =
                  Env.open_component_signature
                    (id :> Identifier.Signature.t)
                    sg env
                in
                return (`Identifier (id :> Identifier.Signature.t), env, sg));
            ]
      | `Dot (parent, name) ->
          resolve_label_parent_reference env parent ~add_canonical
          >>= signature_lookup_result_of_label_parent
          >>= fun (parent', env, sg) ->
          Component_find.opt_module_in_sig sg name >>= fun m ->
          let r' = `Module (parent', name) in
          let sg =
            Tools.signature_of_module_nopath env m |> prefix_signature r'
          in
          let env =
            Env.open_component_signature
              (Reference.Resolved.Signature.identifier r')
              sg env
          in
          return (r', env, sg)
      | `Module (parent, name) ->
          resolve_signature_reference env parent ~add_canonical
          >>= fun (parent', env, sg) ->
          Component_find.opt_module_in_sig sg name >>= fun m ->
          let r' = `Module (parent', name) in
          let sg =
            Tools.signature_of_module_nopath env m |> prefix_signature r'
          in
          let env =
            Env.open_component_signature
              (Reference.Resolved.Signature.identifier r')
              sg env
          in
          return (r', env, sg)
      | `ModuleType (parent, name) ->
          resolve_signature_reference env parent ~add_canonical
          >>= fun (parent', env, sg) ->
          Component_find.opt_module_type_in_sig sg name >>= fun m ->
          let r' = `ModuleType (parent', name) in
          let sg =
            Tools.signature_of_module_type_nopath env m |> prefix_signature r'
          in
          let env =
            Env.open_component_signature
              (Reference.Resolved.Signature.identifier r')
              sg env
          in
          return (r', env, sg)
    in
    (*        Memos2.add memo2 id result; *)
    match Memos2.find_all memo2 id with
    | [] ->
        let resolved = resolve () in
        Memos2.add memo2 id resolved;
        resolved
    | xs ->
        let rec find = function
          | [] ->
              let resolved = resolve () in
              Memos2.add memo2 id resolved;
              resolved
          | Some (p, e, m) :: xs ->
              if verify_resolved_signature env p then
                (*Format.fprintf Format.err_formatter "G";*) Some (p, e, m)
              else find xs
          | None :: xs -> find xs
        in
        find xs

and resolve_value_reference : Env.t -> Value.t -> value_lookup_result option =
  let open Tools.OptionMonad in
  fun env r ->
    match r with
    | `Root (name, _) -> (
        Env.lookup_value_by_name name env >>= function
        | `Value (id, x) -> return (`Identifier id, `V x)
        | `External (id, x) -> return (`Identifier id, `E x) )
    | `Dot (parent, name) -> (
        resolve_label_parent_reference env parent ~add_canonical:true
        >>= signature_lookup_result_of_label_parent
        >>= fun (parent', _, sg) ->
        match Component_find.opt_value_in_sig sg name with
        | Some v -> return (`Value (parent', name), v)
        | None -> None )
    | _ -> failwith "erk"

and resolve_label_reference : Env.t -> Label.t -> Resolved.Label.t option =
  let open Tools.OptionMonad in
  fun env r ->
    match r with
    | `Resolved r -> Some r
    | `Root (name, _) -> (
        Env.lookup_any_by_name name env >>= function
        | `Label id -> return (`Identifier id)
        | _ -> None )
    | `Dot (parent, name) -> (
        resolve_label_parent_reference env parent ~add_canonical:true
        >>= fun (p, _env, sg) ->
        match sg with
        | `S sg ->
            Component_find.opt_label_in_sig sg name >>= fun _ ->
            Some (`Label (p, name))
        | `CS _sg -> None
        | `Page p -> (
            try Some (`Identifier (List.assoc name p)) with _ -> None))
    | `Label (parent, name) -> (
        resolve_label_parent_reference env parent ~add_canonical:true
        >>= fun (p, _, sg) ->
        match sg with
        | `S sg ->
            Component_find.opt_label_in_sig sg name >>= fun _ ->
            Some (`Label (p, name))
        | `CS _sg -> None
        | `Page p -> (
            try Some (`Identifier (List.assoc name p)) with _ -> None)) 

and resolve_reference : Env.t -> t -> Resolved.t option =
  let open Tools.OptionMonad in
  fun env r ->
    match r with
    | `Root (name, `TUnknown) -> (
        Env.lookup_any_by_name name env >>= function
        | `Module (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `ModuleType (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `Value (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `Type (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `Label id ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `Class (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `ClassType (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t))
        | `External (id, _) ->
            return (`Identifier (id :> Odoc_model.Paths.Identifier.t)) )
    | `Resolved r -> Some r
    | (`Root (_, `TModule) | `Module (_, _)) as r ->
        resolve_module_reference env r ~add_canonical:true >>= fun (x, _) ->
        return (x :> Resolved.t)
    | (`Root (_, `TModuleType) | `ModuleType (_, _)) as r ->
        resolve_module_type_reference env r ~add_canonical:true
        >>= fun (x, _) -> return (x :> Resolved.t)
    | (`Root (_, `TType) | `Type (_, _)) as r ->
        resolve_type_reference env r >>= fun (x, _) -> return (x :> Resolved.t)
    | (`Root (_, `TValue) | `Value (_, _)) as r ->
        resolve_value_reference env r >>= fun (x, _) -> return (x :> Resolved.t)
    | (`Root (_, `TLabel) | `Label (_, _)) as r ->
        resolve_label_reference env r >>= fun x -> return (x :> Resolved.t)
    | (`Root (name, `TPage)) -> (
        match Env.lookup_page name env with
        | Some p -> Some (`Identifier (p.Odoc_model.Lang.Page.name :> Identifier.t))
        | None -> None
      )
    | `Dot (_, _) as r ->
        choose
          [
            (fun () ->
              (* Format.fprintf Format.err_formatter "Trying type reference\n%!"; *)
              resolve_type_reference env r >>= fun (x, _) ->
              return (x :> Resolved.t));
            (fun () ->
              (* Format.fprintf Format.err_formatter "Trying module reference\n%!"; *)
              resolve_module_reference env r ~add_canonical:true
              >>= fun (x, _) -> return (x :> Resolved.t));
            (fun () ->
              (* Format.fprintf Format.err_formatter "Trying module_type reference\n%!"; *)
              resolve_module_type_reference env r ~add_canonical:true
              >>= fun (x, _) -> return (x :> Resolved.t));
            (fun () ->
              (* Format.fprintf Format.err_formatter "Trying label reference\n%!"; *)
              resolve_label_reference env r >>= fun x -> return (x :> Resolved.t));
            (fun () ->
              (* Format.fprintf Format.err_formatter "Trying value reference\n%!"; *)
              resolve_value_reference env r >>= fun (x, _) ->
              return (x :> Resolved.t));
          ]
    | _ -> None

and add_canonical_path env m p : Resolved.Module.t =
  (* Format.fprintf Format.err_formatter "add_canonical_path: %a\n%!"
    Component.Fmt.model_resolved_reference
    (p :> Resolved.t); *)
  match p with
  | `Canonical (_, `Resolved _) -> p
  | `Canonical (p, _) | p -> (
      (* Format.fprintf Format.err_formatter "....\n%!"; *)
      match m.Component.Module.canonical with
      | Some (_, cr) -> (
          (*Format.fprintf Format.err_formatter
            "Handling canonical path for %a (cr=%a)\n%!"
            Component.Fmt.model_resolved_reference
            (p :> Resolved.t)
            Component.Fmt.model_reference
            (cr :> Reference.t);*)
          match resolve_module_reference ~add_canonical:false env cr with
          | Some (cp', _) ->
              (* Format.fprintf Format.err_formatter "Got it! %a\n%!" *)
                (* Component.Fmt.model_resolved_reference *)
                (* (cp' :> Reference.Resolved.t); *)
              `Canonical (p, `Resolved cp')
          | _ ->
              (* Format.fprintf Format.err_formatter "No idea :/\n%!"; *)
              `Canonical (p, cr)
          | exception _e ->
              Format.fprintf Format.err_formatter
                "Warning: Failed to look up canonical path for module %a\n\
                 %s\n\
                 %!"
                Component.Fmt.model_resolved_reference
                (p :> Resolved.t)
                (Printexc.get_backtrace ());
              p )
      | None ->
          (* Format.fprintf Format.err_formatter "not canonical\n%!"; *)
          p )

let _ =
  Tools.resolve_module_ref := resolve_module_reference ~add_canonical:false
