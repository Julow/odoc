open Odoc_model.Paths

type maps = {
  module_ : (Ident.module_ * Identifier.Module.t) list;
  module_type : (Ident.module_type * Identifier.ModuleType.t) list;
  signatures : (Ident.signature * Identifier.Signature.t) list;
  type_ : (Ident.type_ * Identifier.Type.t) list;
  path_type :
    (Ident.path_type * Odoc_model.Paths_types.Identifier.path_type) list;
  exception_ : (Ident.exception_ * Identifier.Exception.t) list;
  value_ : (Ident.value * Identifier.Value.t) list;
  method_ : (Ident.method_ * Identifier.Method.t) list;
  instance_variable :
    (Ident.instance_variable * Identifier.InstanceVariable.t) list;
  class_ : (Ident.class_ * Identifier.Class.t) list;
  class_type : (Ident.class_type * Identifier.ClassType.t) list;
  labels : (Ident.label * Identifier.Label.t) list;
  parents : (Ident.parent * Identifier.Parent.t) list;
  label_parents : (Ident.label_parent * Identifier.LabelParent.t) list;
  path_class_type :
    (Ident.path_class_type * Odoc_model.Paths_types.Identifier.path_class_type)
    list;
  any : (Ident.any * Identifier.t) list;
}

let empty =
  {
    module_ = [];
    module_type = [];
    signatures = [];
    type_ = List.map (fun (x, y) -> (y, x)) Component.core_type_ids;
    path_type =
      List.map
        (fun (x, y) ->
          ( (y :> Ident.path_type),
            (x :> Odoc_model.Paths_types.Identifier.path_type) ))
        Component.core_type_ids;
    exception_ = [];
    value_ = [];
    method_ = [];
    instance_variable = [];
    class_ = [];
    class_type = [];
    labels = [];
    label_parents = [];
    parents = [];
    path_class_type = [];
    any = [];
  }

module Opt = Component.Opt

module Path = struct
  let rec module_ map (p : Cpath.module_) : Odoc_model.Paths.Path.Module.t =
    match p with
    | `Substituted x -> module_ map x
    | `Resolved x -> `Resolved (resolved_module map x)
    | `Root x -> `Root x
    | `Dot (p, s) -> `Dot (module_ map p, s)
    | `Forward s -> `Forward s
    | `Apply (m1, m2) -> `Apply (module_ map m1, module_ map m2)

  and module_type map (p : Cpath.module_type) :
      Odoc_model.Paths.Path.ModuleType.t =
    match p with
    | `Substituted x -> module_type map x
    | `Resolved x -> `Resolved (resolved_module_type map x)
    | `Dot (p, n) -> `Dot (module_ map p, n)

  and type_ map (p : Cpath.type_) : Odoc_model.Paths.Path.Type.t =
    match p with
    | `Substituted x -> type_ map x
    | `Resolved x -> `Resolved (resolved_type map x)
    | `Dot (p, n) -> `Dot (module_ map p, n)

  and class_type map (p : Cpath.class_type) : Odoc_model.Paths.Path.ClassType.t
      =
    match p with
    | `Substituted x -> class_type map x
    | `Resolved x -> `Resolved (resolved_class_type map x)
    | `Dot (p, n) -> `Dot (module_ map p, n)

  and resolved_module map (p : Cpath.resolved_module) :
      Odoc_model.Paths.Path.Resolved.Module.t =
    match p with
    | `Local id ->
        `Identifier
          ( try List.assoc id map.module_
            with Not_found ->
              failwith (Format.asprintf "Not_found: %a" Ident.fmt id) )
    | `Substituted x -> resolved_module map x
    | `Identifier (#Odoc_model.Paths.Identifier.Module.t as y) -> `Identifier y
    | `Subst (mty, m) ->
        `Subst (resolved_module_type map mty, resolved_module map m)
    | `SubstAlias (m1, m2) ->
        `SubstAlias (resolved_module map m1, resolved_module map m2)
    | `Hidden h -> `Hidden (resolved_module map h)
    | `Module (p, n) -> `Module (resolved_module map p, n)
    | `Canonical (r, m) -> `Canonical (resolved_module map r, module_ map m)
    | `Apply (m1, m2) -> `Apply (resolved_module map m1, module_ map m2)
    | `Alias (m1, m2) -> `Alias (resolved_module map m1, resolved_module map m2)

  and resolved_module_type map (p : Cpath.resolved_module_type) :
      Odoc_model.Paths.Path.Resolved.ModuleType.t =
    match p with
    | `Identifier (#Odoc_model.Paths.Identifier.ModuleType.t as y) ->
        `Identifier y
    | `Local id -> `Identifier (List.assoc id map.module_type)
    | `ModuleType (p, name) -> `ModuleType (resolved_module map p, name)
    | `Substituted s -> resolved_module_type map s

  and resolved_type map (p : Cpath.resolved_type) :
      Odoc_model.Paths.Path.Resolved.Type.t =
    match p with
    | `Identifier (#Odoc_model.Paths_types.Identifier.path_type as y) ->
        `Identifier y
    | `Local id -> `Identifier (List.assoc id map.path_type)
    | `Type (p, name) -> `Type (resolved_module map p, name)
    | `Class (p, name) -> `Class (resolved_module map p, name)
    | `ClassType (p, name) -> `ClassType (resolved_module map p, name)
    | `Substituted s -> resolved_type map s

  and resolved_class_type map (p : Cpath.resolved_class_type) :
      Odoc_model.Paths.Path.Resolved.ClassType.t =
    match p with
    | `Identifier (#Odoc_model.Paths_types.Identifier.path_class_type as y) ->
        `Identifier y
    | `Local id -> `Identifier (List.assoc id map.path_class_type)
    | `Class (p, name) -> `Class (resolved_module map p, name)
    | `ClassType (p, name) -> `ClassType (resolved_module map p, name)
    | `Substituted s -> resolved_class_type map s

  and resolved_label_parent_reference map (p : Cref.Resolved.label_parent) =
    match p with
    | `Identifier s -> `Identifier s
    | `Local id -> `Identifier (List.assoc id map.label_parents)
    | `SubstAlias (m1, m2) ->
        `SubstAlias (resolved_module map m1, resolved_module_reference map m2)
    | `Module (p, n) -> `Module (resolved_signature_reference map p, n)
    | `Canonical (m1, m2) ->
        `Canonical (resolved_module_reference map m1, module_reference map m2)
    | `ModuleType (p, n) -> `ModuleType (resolved_signature_reference map p, n)
    | `Class (p, n) -> `Class (resolved_signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (resolved_signature_reference map p, n)
    | `Type (p, n) -> `Type (resolved_signature_reference map p, n)

  and resolved_class_signature_reference map (p : Cref.Resolved.class_signature)
      =
    match p with
    | `Identifier s -> `Identifier s
    | `Local id -> `Identifier (List.assoc id map.path_class_type)
    | `Class (p, n) -> `Class (resolved_signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (resolved_signature_reference map p, n)

  and resolved_reference map (p : Cref.Resolved.any) =
    match p with
    | `Identifier s -> `Identifier s
    | `Local id ->
        `Identifier
          ( try List.assoc id map.any
            with Not_found ->
              failwith
                (Format.asprintf "XXX Failed to find id: %a" Ident.fmt id) )
    | `SubstAlias (m1, m2) ->
        `SubstAlias (resolved_module map m1, resolved_module_reference map m2)
    | `Module (p, n) -> `Module (resolved_signature_reference map p, n)
    | `Canonical (m1, m2) ->
        `Canonical (resolved_module_reference map m1, module_reference map m2)
    | `ModuleType (p, n) -> `ModuleType (resolved_signature_reference map p, n)
    | `Class (p, n) -> `Class (resolved_signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (resolved_signature_reference map p, n)
    | `Type (p, n) -> `Type (resolved_signature_reference map p, n)
    | `Constructor (p, n) -> `Constructor (resolved_datatype_reference map p, n)
    | `Field (p, n) -> `Field (resolved_parent_reference map p, n)
    | `Extension (p, n) -> `Extension (resolved_signature_reference map p, n)
    | `Exception (p, n) -> `Exception (resolved_signature_reference map p, n)
    | `Value (p, n) -> `Value (resolved_signature_reference map p, n)
    | `Method (p, n) -> `Method (resolved_class_signature_reference map p, n)
    | `InstanceVariable (p, n) ->
        `InstanceVariable (resolved_class_signature_reference map p, n)
    | `Label (p, n) -> `Label (resolved_label_parent_reference map p, n)

  and resolved_parent_reference map (p : Cref.Resolved.parent) =
    match p with
    | `Identifier s -> `Identifier s
    | `Local id -> `Identifier (List.assoc id map.parents)
    | `SubstAlias (m1, m2) ->
        `SubstAlias (resolved_module map m1, resolved_module_reference map m2)
    | `Module (p, n) -> `Module (resolved_signature_reference map p, n)
    | `Canonical (m1, m2) ->
        `Canonical (resolved_module_reference map m1, module_reference map m2)
    | `ModuleType (p, n) -> `ModuleType (resolved_signature_reference map p, n)
    | `Class (p, n) -> `Class (resolved_signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (resolved_signature_reference map p, n)
    | `Type (p, n) -> `Type (resolved_signature_reference map p, n)

  and resolved_datatype_reference map (p : Cref.Resolved.datatype) =
    match p with
    | `Identifier id -> `Identifier id
    | `Local id -> `Identifier (List.assoc id map.type_)
    | `Type (p, n) -> `Type (resolved_signature_reference map p, n)

  and resolved_signature_reference map (p : Cref.Resolved.signature) =
    match p with
    | `Identifier s -> `Identifier s
    | `Local id ->
        `Identifier
          ( try List.assoc id map.signatures
            with Not_found ->
              failwith (Format.asprintf "Not_found finding %a\n%!" Ident.fmt id)
          )
    | `SubstAlias (m1, m2) ->
        `SubstAlias (resolved_module map m1, resolved_module_reference map m2)
    | `Module (p, n) -> `Module (resolved_signature_reference map p, n)
    | `Canonical (m1, m2) ->
        `Canonical (resolved_module_reference map m1, module_reference map m2)
    | `ModuleType (p, n) -> `ModuleType (resolved_signature_reference map p, n)

  and resolved_module_reference map (p : Cref.Resolved.module_) =
    match p with
    | `Identifier p -> `Identifier p
    | `Local id -> `Identifier (List.assoc id map.module_)
    | `SubstAlias (m1, m2) ->
        `SubstAlias (resolved_module map m1, resolved_module_reference map m2)
    | `Module (p, m) -> `Module (resolved_signature_reference map p, m)
    | `Canonical (m1, m2) ->
        `Canonical (resolved_module_reference map m1, module_reference map m2)

  and label_parent_reference map (p : Cref.label_parent) =
    match p with
    | `Resolved p -> `Resolved (resolved_label_parent_reference map p)
    | `Root (name, tag) -> `Root (name, tag)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Module (p, n) -> `Module (signature_reference map p, n)
    | `ModuleType (p, n) -> `ModuleType (signature_reference map p, n)
    | `Class (p, n) -> `Class (signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (signature_reference map p, n)
    | `Type (p, n) -> `Type (signature_reference map p, n)

  and parent_reference map (p : Cref.parent) =
    match p with
    | `Resolved p -> `Resolved (resolved_parent_reference map p)
    | `Root (name, tag) -> `Root (name, tag)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Module (p, n) -> `Module (signature_reference map p, n)
    | `ModuleType (p, n) -> `ModuleType (signature_reference map p, n)
    | `Class (p, n) -> `Class (signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (signature_reference map p, n)
    | `Type (p, n) -> `Type (signature_reference map p, n)

  and signature_reference map (p : Cref.signature) =
    match p with
    | `Resolved p -> `Resolved (resolved_signature_reference map p)
    | `Root (name, tag) -> `Root (name, tag)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Module (p, n) -> `Module (signature_reference map p, n)
    | `ModuleType (p, n) -> `ModuleType (signature_reference map p, n)

  and module_reference map (p : Cref.module_) =
    match p with
    | `Resolved r -> `Resolved (resolved_module_reference map r)
    | `Root (name, tag) -> `Root (name, tag)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Module (p, n) -> `Module (signature_reference map p, n)

  and datatype_reference map (p : Cref.datatype) :
      Odoc_model.Paths.Reference.DataType.t =
    match p with
    | `Resolved p -> `Resolved (resolved_datatype_reference map p)
    | `Root (name, tag) -> `Root (name, tag)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Type (p, n) -> `Type (signature_reference map p, n)

  and class_signature_reference map (p : Cref.class_signature) =
    match p with
    | `Class (p, n) -> `Class (signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (signature_reference map p, n)
    | `Resolved r -> `Resolved (resolved_class_signature_reference map r)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Root (p, n) -> `Root (p, n)

  and reference map (p : Cref.any) =
    match p with
    | `Resolved r -> `Resolved (resolved_reference map r)
    | `Root (name, tag) -> `Root (name, tag)
    | `Dot (p, n) -> `Dot (label_parent_reference map p, n)
    | `Module (p, n) -> `Module (signature_reference map p, n)
    | `ModuleType (p, n) -> `ModuleType (signature_reference map p, n)
    | `Class (p, n) -> `Class (signature_reference map p, n)
    | `ClassType (p, n) -> `ClassType (signature_reference map p, n)
    | `Type (p, n) -> `Type (signature_reference map p, n)
    | `Constructor (d, n) -> `Constructor (datatype_reference map d, n)
    | `Field (p, n) -> `Field (parent_reference map p, n)
    | `Extension (p, n) -> `Extension (signature_reference map p, n)
    | `Exception (p, n) -> `Exception (signature_reference map p, n)
    | `Value (p, n) -> `Value (signature_reference map p, n)
    | `Method (p, n) -> `Method (class_signature_reference map p, n)
    | `InstanceVariable (p, n) ->
        `InstanceVariable (class_signature_reference map p, n)
    | `Label (p, n) -> `Label (label_parent_reference map p, n)
end
