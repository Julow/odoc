#if OCAML_VERSION >= (4, 14, 0)

open Odoc_model
open Odoc_model.Paths
open Odoc_model.Names
module Kind = Shape.Sig_component_kind

let ( >>= ) m f = match m with Some x -> f x | None -> None

type t = Shape.t * Odoc_model.Paths.Identifier.SourceLocation.t Shape.Uid.Map.t

(** Project an identifier into a shape. *)
let rec shape_of_id lookup_shape :
    [< Identifier.NonSrc.t_pv ] Identifier.id -> Shape.t option =
  let proj parent kind name =
    let item = Shape.Item.make name kind in
    match shape_of_id lookup_shape (parent :> Identifier.NonSrc.t) with
    | Some shape -> Some (Shape.proj shape item)
    | None -> None
  in
  fun id ->
    match id.iv with
    | `Root (_, name) ->
        lookup_shape (ModuleName.to_string name) >>= fun (_, (shape, _)) ->
        Some shape
    | `Module (parent, name) ->
        proj parent Kind.Module (ModuleName.to_string name)
    | `Result parent ->
        (* Apply the functor to an empty signature. This doesn't seem to cause
           any problem, as the shape would stop resolve on an item inside the
           result of the function, which is what we want. *)
        shape_of_id lookup_shape (parent :> Identifier.NonSrc.t)
        >>= fun parent ->
        Some (Shape.app parent ~arg:(Shape.str Shape.Item.Map.empty))
    | `ModuleType (parent, name) ->
        proj parent Kind.Module_type (ModuleTypeName.to_string name)
    | `Type (parent, name) -> proj parent Kind.Type (TypeName.to_string name)
    | `Value (parent, name) -> proj parent Kind.Value (ValueName.to_string name)
    | `Extension (parent, name) ->
        proj parent Kind.Extension_constructor (ExtensionName.to_string name)
    | `Exception (parent, name) ->
        proj parent Kind.Extension_constructor (ExceptionName.to_string name)
    | `Class (parent, name) -> proj parent Kind.Class (ClassName.to_string name)
    | `ClassType (parent, name) ->
        proj parent Kind.Class_type (ClassTypeName.to_string name)
    | `Page _ | `LeafPage _ | `Label _ | `CoreType _ | `CoreException _
    | `Constructor _ | `Field _ | `Method _ | `InstanceVariable _ | `Parameter _
      ->
        (* Not represented in shapes. *)
        None

module MkId = Identifier.Mk

let unit_of_uid uid =
  match uid with
  | Shape.Uid.Compilation_unit s -> Some s
  | Item { comp_unit; id = _ } -> Some comp_unit
  | Predef _ -> None
  | Internal -> None

let lookup_shape :
    (string -> (Lang.Compilation_unit.t * t) option) ->
    Shape.t ->
    Identifier.SourceLocation.t option =
 fun lookup_unit query ->
  let module Reduce = Shape.Make_reduce (struct
    type env = unit
    let fuel = 10
    let read_unit_shape ~unit_name =
      match lookup_unit unit_name with
      | Some (_, (shape, _)) -> Some shape
      | None -> None
    let find_shape _ _ = raise Not_found
  end) in
  let result = try Some (Reduce.reduce () query) with Not_found -> None in
  result >>= fun result ->
  result.uid >>= fun uid ->
  unit_of_uid uid >>= fun unit_name ->
  lookup_unit unit_name >>= fun (unit, (_, uid_to_anchor)) ->
  match Shape.Uid.Map.find_opt uid uid_to_anchor with
  | Some x -> Some x
  | None -> (
      match unit.source_info with
      | Some si -> Some (MkId.source_location_mod si.id)
      | None -> None)

let lookup_def :
    (string -> (Lang.Compilation_unit.t * t) option) ->
    Identifier.NonSrc.t ->
    Identifier.SourceLocation.t option =
 fun lookup_unit id ->
  match shape_of_id lookup_unit id with
  | None -> None
  | Some query -> lookup_shape lookup_unit query

#else

type t = unit

let lookup_def _ _id = None

#endif
