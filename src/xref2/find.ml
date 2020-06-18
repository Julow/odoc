open Component

type module_ =
  [ `M of Component.Module.t | `M_removed of Cpath.Resolved.module_ ]

type datatype = [ `T of TypeDecl.t | `T_removed of TypeExpr.t ]

type class_ = [ `C of Class.t | `CT of ClassType.t ]

type type_ = [ datatype | class_ ]

type value = [ `V of Value.t | `E of External.t ]

type any_not_removed = [ `M of Module.t | `T of TypeDecl.t | class_ | value ]

type any = [ module_ | type_ | value ]

module N = Ident.Name

let rec find_map f = function
  | hd :: tl -> (
      match f hd with Some _ as found -> found | None -> find_map f tl )
  | [] -> None

class ['a] module_' name =
  object
    constraint 'a = [> module_ ]

    method module_ id m_delayed : 'a option =
      if N.typed_module id = name then Some (`M (Delayed.get m_delayed))
      else None

    method removed_module id mp : 'a option =
      if N.typed_module id = name then Some (`M_removed mp) else None
  end

class ['a] datatype' name =
  object
    constraint 'a = [> datatype ]

    method type_ id t_delayed : 'a option =
      if N.type_ id = name then Some (`T (Delayed.get t_delayed)) else None

    method removed_type id p : 'a option =
      if N.type_ id = name then Some (`T_removed p) else None
  end

class ['a] class_' name =
  object
    method class_ id c : 'a option = if N.class_ id = name then Some (`C c) else None

    method class_type id ct : 'a option =
      if N.class_type id = name then Some (`CT ct) else None
  end

class ['a] find_in_sig =
  object (self)
    constraint 'a = [< any_not_removed ]

    (* Signature items *)
    method module_ _ _ = None

    method module_type _ _ = None

    method type_ _ _ = None
    method class_ _ _ = None
    method class_type _ _ = None

    (* method type_ _ _ = None *)
    method include_ i = self#signature i.Include.expansion_

    (* Signatures *)
    method signature sg = find_map self#signature_item sg.Signature.items

    method signature_item : _ -> 'a option =
      function
      | Signature.Module (id, _, m_delayed) -> self#module_ id m_delayed
      (* | ModuleSubstitution of Ident.module_ * ModuleSubstitution.t *)
      | ModuleType (id, mt_delayed) -> self#module_type id mt_delayed
      | Type (id, _, t_delayed) -> self#type_ id t_delayed
      (* | TypeSubstitution of Ident.type_ * TypeDecl.t *)
      (* | Exception of Ident.exception_ * Exception.t *)
      (* | TypExt of Extension.t *)
      (* | Value of Ident.value * Value.t *)
      (* | External of Ident.value * External.t *)
      | Class (id, _, c) -> self#class_ id c
      | ClassType (id, _, ct) -> self#class_type id ct
      | Include inc -> self#include_ inc
      (* | Open of Open.t *)
      (* | Comment of CComment.docs_or_stop *)
      | _ -> None
  end

class ['a] find_in_sig_maybe_removed =
  object (self)
    constraint 'a = [< any ]

    inherit ['a] find_in_sig as super

    method removed_module _ _ = None

    method removed_type _ _ = None

    method! signature sg =
      match super#signature sg with
      | Some _ as x -> x
      | None -> find_map self#removed_item sg.Signature.removed

    method removed_item : _ -> 'a option =
      function
      | RModule (id, mp) -> self#removed_module id mp
      | RType (id, te) -> self#removed_type id te
  end

class ['a] module_in_sig name =
  object
    inherit ['a] find_in_sig_maybe_removed

    inherit! ['a] module_' name
  end

class ['a] type_in_sig name =
  object
    inherit ['a] find_in_sig

    inherit! ['a] datatype' name

    inherit! ['a] class_' name
  end

class ['a] datatype_in_sig name =
  object
    inherit ['a] find_in_sig

    inherit! ['a] datatype' name
  end

class ['a] class_in_sig name =
  object
    inherit ['a] find_in_sig

    inherit! ['a] class_' name
  end

let module_in_sig sg name = (new module_in_sig name)#signature sg

let type_in_sig sg name = (new type_in_sig name)#signature sg

let datatype_in_sig sg name = (new datatype_in_sig name)#signature sg

let class_in_sig sg name = (new class_in_sig name)#signature sg

let typename_of_typeid (`LType (n, _) | `LCoreType n) = n

let any_in_type (typ : TypeDecl.t) name =
  let rec find_cons = function
    | ({ TypeDecl.Constructor.name = name'; _ } as cons) :: _ when name' = name
      ->
        Some (`Constructor cons)
    | _ :: tl -> find_cons tl
    | [] -> None
  in
  let rec find_field = function
    | ({ TypeDecl.Field.name = name'; _ } as field) :: _ when name' = name ->
        Some (`Field field)
    | _ :: tl -> find_field tl
    | [] -> None
  in
  match typ.representation with
  | Some (Variant cons) -> find_cons cons
  | Some (Record fields) -> find_field fields
  | Some Extensible | None -> None

let any_in_typext (typext : Extension.t) name =
  let rec inner = function
    | ({ Extension.Constructor.name = name'; _ } as cons) :: _ when name' = name
      ->
        Some (`ExtConstructor (typext, cons))
    | _ :: tl -> inner tl
    | [] -> None
  in
  inner typext.constructors

let any_in_comment d name =
  let rec inner xs =
    match xs with
    | elt :: rest -> (
        match elt.Odoc_model.Location_.value with
        | `Heading (_, label, _) when Ident.Name.label label = name ->
            Some (`Label label)
        | _ -> inner rest )
    | [] -> None
  in
  inner d

let any_in_sig (s : Signature.t) name =
  let module N = Ident.Name in
  let rec inner_removed = function
    | Signature.RModule (id, m) :: _ when N.typed_module id = name ->
        Some (`Removed (`Module (id, m)))
    | RType (id, t) :: _ when N.type_ id = name ->
        Some (`Removed (`Type (id, t)))
    | _ :: tl -> inner_removed tl
    | [] -> None
  in
  let rec inner = function
    | Signature.Module (id, rec_, m) :: _ when N.typed_module id = name ->
        Some (`Module (id, rec_, m))
    | ModuleSubstitution (id, ms) :: _ when N.typed_module id = name ->
        Some (`ModuleSubstitution (id, ms))
    | ModuleType (id, mt) :: _ when N.module_type id = name ->
        Some (`ModuleType (id, mt))
    | Type (id, rec_, t) :: _ when N.type_ id = name ->
        Some (`Type (id, rec_, t))
    | TypeSubstitution (id, ts) :: _ when N.type_ id = name ->
        Some (`TypeSubstitution (id, ts))
    | Exception (id, exc) :: _ when N.exception_ id = name ->
        Some (`Exception (id, exc))
    | Value (id, v) :: _ when N.value id = name -> Some (`Value (id, v))
    | External (id, vex) :: _ when N.value id = name ->
        Some (`External (id, vex))
    | Class (id, rec_, c) :: _ when N.class_ id = name ->
        Some (`Class (id, rec_, c))
    | ClassType (id, rec_, ct) :: _ when N.class_type id = name ->
        Some (`ClassType (id, rec_, ct))
    | Include inc :: tl -> (
        match inner inc.Include.expansion_.items with
        | Some _ as found -> found
        | None -> inner tl )
    | Type (id, _, t) :: tl -> (
        let typ = Delayed.get t in
        match any_in_type typ name with
        | Some (`Constructor cons) ->
            Some (`Constructor (typename_of_typeid id, typ, cons))
        | Some (`Field field) ->
            Some (`Field (typename_of_typeid id, typ, field))
        | None -> inner tl )
    | TypExt typext :: tl -> (
        match any_in_typext typext name with
        | Some _ as found -> found
        | None -> inner tl )
    | Comment (`Docs d) :: tl -> (
        match any_in_comment d name with
        | Some _ as found -> found
        | None -> inner tl )
    | _ :: tl -> inner tl
    | [] -> inner_removed s.removed
  in
  inner s.items

(** Search a module or module type *)
let signature_in_sig (s : Signature.t) name =
  let module N = Ident.Name in
  let rec inner = function
    | Signature.Module (id, rec_, m) :: _ when N.typed_module id = name ->
        Some (`Module (id, rec_, m))
    | ModuleType (id, mt) :: _ when N.module_type id = name ->
        Some (`ModuleType (id, mt))
    | Include inc :: tl -> (
        match inner inc.Include.expansion_.items with
        | Some _ as found -> found
        | None -> inner tl )
    | _ :: tl -> inner tl
    | [] -> None
  in
  inner s.items

let module_type_in_sig (s : Signature.t) name =
  let rec inner = function
    | Signature.ModuleType (id, m) :: _ when Ident.Name.module_type id = name ->
        Some (Delayed.get m)
    | Signature.Include i :: rest -> (
        match inner i.Include.expansion_.items with
        | Some _ as found -> found
        | None -> inner rest )
    | _ :: rest -> inner rest
    | [] -> None
  in
  inner s.items

let opt_module_type_in_sig s name =
  try Some (module_type_in_sig s name) with _ -> None

let opt_value_in_sig s name : value option =
  let rec inner = function
    | Signature.Value (id, m) :: _ when Ident.Name.value id = name ->
        Some (`V m)
    | Signature.External (id, e) :: _ when Ident.Name.value id = name ->
        Some (`E e)
    | Signature.Include i :: rest -> (
        match inner i.Include.expansion_.items with
        | Some m -> Some m
        | None -> inner rest )
    | _ :: rest -> inner rest
    | [] -> None
  in

  inner s.Signature.items

let opt_label_in_sig s name =
  let rec inner = function
    | Signature.Comment (`Docs d) :: rest -> (
        let rec inner' xs =
          match xs with
          | elt :: rest -> (
              match elt.Odoc_model.Location_.value with
              | `Heading (_, label, _) when Ident.Name.label label = name ->
                  Some label
              | _ -> inner' rest )
          | _ -> None
        in
        match inner' d with None -> inner rest | x -> x )
    | Signature.Include i :: rest -> (
        match inner i.Include.expansion_.items with
        | Some _ as x -> x
        | None -> inner rest )
    | _ :: rest -> inner rest
    | [] -> None
  in
  inner s.Signature.items

let find_in_sig sg f =
  let rec inner = function
    | Signature.Include i :: tl -> (
        match inner i.Include.expansion_.items with
        | Some _ as x -> x
        | None -> inner tl )
    | hd :: tl -> ( match f hd with Some _ as x -> x | None -> inner tl )
    | [] -> None
  in
  inner sg.Signature.items

let exception_in_sig s name =
  find_in_sig s (function
    | Signature.Exception (id, e) when Ident.Name.exception_ id = name -> Some e
    | _ -> None)

let extension_in_sig s name =
  let rec inner = function
    | ec :: _ when ec.Extension.Constructor.name = name -> Some ec
    | _ :: tl -> inner tl
    | [] -> None
  in
  find_in_sig s (function
    | Signature.TypExt t -> inner t.Extension.constructors
    | _ -> None)

let label_parent_in_sig s name =
  let module N = Ident.Name in
  find_in_sig s (function
    | Signature.Module (id, _, m) when N.typed_module id = name ->
        Some (`M (Component.Delayed.get m))
    | ModuleType (id, mt) when N.module_type id = name ->
        Some (`MT (Component.Delayed.get mt))
    | Type (id, _, t) when N.type_ id = name ->
        Some (`T (Component.Delayed.get t))
    | Class (id, _, c) when N.class_ id = name -> Some (`C c)
    | ClassType (id, _, c) when N.class_type id = name -> Some (`CT c)
    | _ -> None)

let any_in_type_in_sig s name =
  find_in_sig s (function
    | Signature.Type (id, _, t) -> (
        match any_in_type (Component.Delayed.get t) name with
        | Some x -> Some (typename_of_typeid id, x)
        | None -> None )
    | _ -> None)

let find_in_class_signature cs f =
  let rec inner = function
    | ClassSignature.Inherit ct_expr :: tl -> (
        match inner_inherit ct_expr with Some _ as x -> x | None -> inner tl )
    | it :: tl -> ( match f it with Some _ as x -> x | None -> inner tl )
    | [] -> None
  and inner_inherit = function
    | Constr _ -> None
    | Signature cs -> inner cs.items
  in
  inner cs.ClassSignature.items

let any_in_class_signature cs name =
  find_in_class_signature cs (function
    | ClassSignature.Method (id, m) when Ident.Name.method_ id = name ->
        Some (`Method m)
    | InstanceVariable (id, iv) when Ident.Name.instance_variable id = name ->
        Some (`InstanceVariable iv)
    | _ -> None)

let method_in_class_signature cs name =
  find_in_class_signature cs (function
    | ClassSignature.Method (id, m) when Ident.Name.method_ id = name -> Some m
    | _ -> None)

let instance_variable_in_class_signature cs name =
  find_in_class_signature cs (function
    | ClassSignature.InstanceVariable (id, iv)
      when Ident.Name.instance_variable id = name ->
        Some (`InstanceVariable iv)
    | _ -> None)
