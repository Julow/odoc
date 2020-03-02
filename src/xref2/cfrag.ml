(*open Odoc_model.Paths*)
open Odoc_model.Names

type resolved_signature =
  [ `Root
  | `Subst of Cpath.Resolved.module_type * resolved_module
  | `SubstAlias of Cpath.Resolved.module_ * resolved_module
  | `Module of resolved_signature * ModuleName.t ]

and resolved_module =
  [ `Subst of Cpath.Resolved.module_type * resolved_module
  | `SubstAlias of Cpath.Resolved.module_ * resolved_module
  | `Module of resolved_signature * ModuleName.t ]

and resolved_type =
  [ `Type of resolved_signature * TypeName.t
  | `Class of resolved_signature * ClassName.t
  | `ClassType of resolved_signature * ClassTypeName.t ]

(* and signature = [ `Resolved of resolved_signature ] *)


type signature = [
  | `Resolved of resolved_signature
  | `Dot of signature * string
]

and module_ = [
  | `Resolved of resolved_module
  | `Dot of signature * string
]

and type_ = [
  | `Resolved of resolved_type
  | `Dot of signature * string
]

type resolved_base_name =
  | RBase
  | RBranch of ModuleName.t * resolved_signature

type base_name =
  | Base
  | Branch of ModuleName.t * signature

let rec resolved_signature_split_parent : resolved_signature -> resolved_base_name = function
  | `Root -> RBase
  | `Subst(_, p) -> resolved_signature_split_parent (p :> resolved_signature)
  | `SubstAlias(_, p) -> resolved_signature_split_parent (p :> resolved_signature)
  | `Module(p, name) ->
    match resolved_signature_split_parent p with
    | RBase -> RBranch(name, `Root)
    | RBranch(base, m) -> RBranch(base, `Module(m, name))


let rec signature_split_parent : signature -> base_name =
  function
  | `Resolved r -> begin
      match resolved_signature_split_parent r with
      | RBase -> Base
      | RBranch(base, m) -> Branch(base, `Resolved m)
    end
  | `Dot(m,name) -> begin
      match signature_split_parent m with
      | Base -> Branch(ModuleName.of_string name,`Resolved `Root)
      | Branch(base,m) -> Branch(base, `Dot(m,name))
    end

let rec resolved_module_split : resolved_module -> string * resolved_module option = function
| `Subst(_,p) -> resolved_module_split p
| `SubstAlias(_,p) -> resolved_module_split p
| `Module (m, name) -> begin
    match resolved_signature_split_parent m with
    | RBase -> (ModuleName.to_string name, None)
    | RBranch(base,m) -> ModuleName.to_string base, Some (`Module(m,name))
  end

  let module_split : module_ -> string * module_ option = function
  | `Resolved r ->
    let base, m = resolved_module_split r in
    let m =
      match m with
      | None -> None
      | Some m -> Some (`Resolved m)
    in
    base, m
  | `Dot(m, name) ->
    match signature_split_parent m with
    | Base -> name, None
    | Branch(base, m) -> ModuleName.to_string base, Some(`Dot(m, name))

let resolved_type_split : resolved_type -> string * resolved_type option =
function
| `Type (m,name) -> begin
    match resolved_signature_split_parent m with
    | RBase -> TypeName.to_string name, None
    | RBranch(base, m) -> ModuleName.to_string base, Some (`Type(m, name))
  end
| `Class(m, name) -> begin
    match resolved_signature_split_parent m with
    | RBase -> ClassName.to_string name, None
    | RBranch(base, m) -> ModuleName.to_string base, Some (`Class(m, name))
  end
| `ClassType(m, name) -> begin
    match resolved_signature_split_parent m with
    | RBase -> ClassTypeName.to_string name, None
    | RBranch(base, m) -> ModuleName.to_string base, Some (`ClassType(m, name))
  end

  let type_split : type_ -> string * type_ option = function
      | `Resolved r ->
        let base, m = resolved_type_split r in
        let m =
          match m with
          | None -> None
          | Some m -> Some (`Resolved m)
        in
        base, m
      | `Dot(m, name) ->
        match signature_split_parent m with
        | Base -> name, None
        | Branch(base, m) -> ModuleName.to_string base, Some(`Dot(m, name))
