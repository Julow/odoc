open Odoc_model

type 'e t = { error : 'e; caused : 'e list }

module Tools_error = struct
  open Paths
  (** Errors raised by Tools *)

  type tools_error =
    [ `Local of
      Env.t * Ident.path_module
      (* Internal error: Found local path during lookup *)
    | `LocalMT of
      Env.t * Ident.module_type
      (* Internal error: Found local path during lookup *)
    | `LocalType of
      Env.t * Ident.path_type
      (* Internal error: Found local path during lookup *)
    | `Lookup_failure of
      Identifier.Path.Module.t
      (* Could not find the module in the environment *)
    | `Lookup_failureMT of
      Identifier.ModuleType.t
      (* Could not find the module in the environment *)
    | `Lookup_failureT of
      Identifier.Path.Type.t
      (* Could not find the module in the environment *)
    | `Lookup_failure_root of string (* Could not find the root module *)
    | `Unresolved_apply (* [`Apply] argument is not [`Resolved] *)
    | `Find_failure
      (* Internal error: the module was not found in the parent signature *)
    | `ApplyNotFunctor
      (* Internal error: attempt made to apply a module that's not a functor *)
    | `OpaqueModule (* The module does not have an expansion *)
    | `Class_replaced
      (* Class was replaced with a destructive substitution and we're not sure
          what to do now *)
    | `Fragment_root
    | `UnresolvedForwardPath
    | `UnresolvedPath of
      [ `Module of Cpath.module_ | `ModuleType of Cpath.module_type ]
      (* Failed to resolve a module path when applying a fragment item *)
    | `UnexpandedTypeOf of
      Component.ModuleType.type_of_desc
      (* The `module type of` expression could not be expanded *) ]

  type 'a tools_result = ('a, tools_error t) Result.result

  let make_error error : 'a tools_result = Error { error; caused = [] }

  let add_cause causes = function
    | Ok _ as x -> x
    | Error e -> Error { e with caused = causes :: e.caused }

  let pp : Format.formatter -> tools_error -> unit =
   fun fmt err ->
    match err with
    | `OpaqueModule -> Format.fprintf fmt "Opaque module"
    | `UnresolvedForwardPath -> Format.fprintf fmt "Unresolved forward path"
    | `UnresolvedPath (`Module p) when Cpath.is_module_forward p ->
        Format.fprintf fmt "Unresolved forward module path %a"
          Component.Fmt.module_path p
    | `UnresolvedPath (`Module p) ->
        Format.fprintf fmt "Unresolved module path %a" Component.Fmt.module_path
          p
    | `UnresolvedPath (`ModuleType p) ->
        Format.fprintf fmt "Unresolved module type path %a"
          Component.Fmt.module_type_path p
    | `LocalMT (_, id) -> Format.fprintf fmt "Local id found: %a" Ident.fmt id
    | `Local (_, id) -> Format.fprintf fmt "Local id found: %a" Ident.fmt id
    | `LocalType (_, id) -> Format.fprintf fmt "Local id found: %a" Ident.fmt id
    | `Unresolved_apply -> Format.fprintf fmt "Unresolved apply"
    | `Find_failure -> Format.fprintf fmt "Find failure"
    | `Lookup_failure m ->
        Format.fprintf fmt "Lookup failure (module): %a"
          Component.Fmt.model_identifier
          (m :> Odoc_model.Paths.Identifier.t)
    | `Lookup_failure_root r ->
        Format.fprintf fmt "Lookup failure (root module): %s" r
    | `Lookup_failureMT m ->
        Format.fprintf fmt "Lookup failure (module type): %a"
          Component.Fmt.model_identifier
          (m :> Odoc_model.Paths.Identifier.t)
    | `Lookup_failureT m ->
        Format.fprintf fmt "Lookup failure (type): %a"
          Component.Fmt.model_identifier
          (m :> Odoc_model.Paths.Identifier.t)
    | `ApplyNotFunctor -> Format.fprintf fmt "Apply module is not a functor"
    | `Class_replaced -> Format.fprintf fmt "Class replaced"
    | `UnexpandedTypeOf t ->
        Format.fprintf fmt "Unexpanded `module type of` expression: %a"
          Component.Fmt.module_type_type_of_desc t
    | `Fragment_root -> Format.fprintf fmt "Fragment root"
end

(* Ugh. we need to determine whether this was down to an unexpanded module type error. This is horrendous. *)
let is_unexpanded_module_type_of = function
  | `UnexpandedTypeOf _ -> true
  | _ -> false

let rec cpath_is_root = function
  | `Root name -> Some (`Root name)
  | `Substituted p' | `Dot (p', _) -> cpath_is_root p'
  | `Apply (a, b) -> (
      match cpath_is_root a with Some _ as a -> a | None -> cpath_is_root b)
  | _ -> None

let rec mt_cpath_is_root = function
  | `Substituted p' -> mt_cpath_is_root p'
  | `Dot (p', _) -> cpath_is_root p'
  | _ -> None

(** [Some (`Root _)] for errors during lookup of root modules or [None] for
    other errors. *)
let is_root_error = function
  | `UnresolvedPath (`Module cp) -> cpath_is_root cp
  | `UnresolvedPath (`ModuleType cp) -> mt_cpath_is_root cp
  | `Lookup_failure (`Root (_, name)) ->
      Some (`Root (Names.ModuleName.to_string name))
  | `Lookup_failure_root name -> Some (`Root name)
  | `OpaqueModule ->
      (* Don't turn OpaqueModule warnings into errors *)
      Some `OpaqueModule
  | _ -> None

let is_root_error ~what = function
  | Some e -> is_root_error e.error
  | None -> (
      match what with
      | `Include (Component.Include.Alias cp) -> cpath_is_root cp
      | `Module (`Root (_, name)) ->
          Some (`Root (Names.ModuleName.to_string name))
      | _ -> None)

open Paths

type what =
  [ `Functor_parameter of Identifier.FunctorParameter.t
  | `Value of Identifier.Value.t
  | `Class of Identifier.Class.t
  | `Class_type of Identifier.ClassType.t
  | `Module of Identifier.Module.t
  | `Module_type of Identifier.Signature.t
  | `Module_path of Cpath.module_
  | `Module_type_path of Cpath.module_type
  | `Module_type_U of Component.ModuleType.U.expr
  | `Include of Component.Include.decl
  | `Package of Cpath.module_type
  | `Type of Cfrag.type_
  | `Type_path of Cpath.type_
  | `With_module of Cfrag.module_
  | `With_module_type of Cfrag.module_type
  | `With_type of Cfrag.type_
  | `Module_type_expr of Component.ModuleType.expr
  | `Module_type_u_expr of Component.ModuleType.U.expr
  | `Child of Reference.t ]

let report ~(what : what) ?(tools_error : _ t option) action =
  let action =
    match action with
    | `Expand -> "compile expansion for"
    | `Resolve_module_type -> "resolve type of"
    | `Resolve -> "resolve"
  in
  let pp_tools_error fmt = function
    | Some e -> Format.fprintf fmt " (%a)" Tools_error.pp e.error
    | None -> ()
  in
  let open Component.Fmt in
  let report_internal_error () =
    let r subject pp_a a =
      Lookup_failures.report_internal "Failed to %s %s %a%a" action subject pp_a
        a pp_tools_error tools_error
    in
    let fmt_id fmt id = model_identifier fmt (id :> Paths.Identifier.t) in
    match what with
    | `Functor_parameter id -> r "functor parameter" fmt_id id
    | `Value id -> r "value" fmt_id id
    | `Class id -> r "class" fmt_id id
    | `Class_type id -> r "class type" fmt_id id
    | `Module id -> r "module" fmt_id id
    | `Module_type id -> r "module type" fmt_id id
    | `Module_path path -> r "module path" module_path path
    | `Module_type_path path -> r "module type path" module_type_path path
    | `Module_type_U expr -> r "module type expr" u_module_type_expr expr
    | `Include decl -> r "include" include_decl decl
    | `Package path ->
        r "module package" module_type_path (path :> Cpath.module_type)
    | `Type cfrag -> r "type" type_fragment cfrag
    | `Type_path path -> r "type" type_path path
    | `With_module frag -> r "module substitution" module_fragment frag
    | `With_module_type frag ->
        r "module type substitution" module_type_fragment frag
    | `With_type frag -> r "type substitution" type_fragment frag
    | `Module_type_expr cexpr ->
        r "module type expression" module_type_expr cexpr
    | `Module_type_u_expr cexpr ->
        r "module type u expression" u_module_type_expr cexpr
    | `Child rf -> r "child reference" model_reference rf
  in
  match is_root_error ~what tools_error with
  | Some (`Root name) -> Lookup_failures.report_root ~name
  | Some `OpaqueModule -> report_internal_error ()
  | None -> report_internal_error ()
