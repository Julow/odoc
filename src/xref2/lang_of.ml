open Odoc_model
open Odoc_model.Paths

include Lang_of_t

module ExtractIDs = struct
  open Component
  open Odoc_model.Names

  let rec exception_ parent map id =
    let identifier =
      `Exception (parent, ExceptionName.of_string (Ident.Name.exception_ id))
    in
    { map with exception_ = (id, identifier) :: map.exception_ }

  and type_decl parent map id =
    let identifier = `Type (parent, TypeName.of_string (Ident.Name.type_ id)) in
    {
      map with
      type_ = (id, identifier) :: map.type_;
      path_type = ((id :> Ident.path_type), identifier) :: map.path_type;
      label_parents =
        ((id :> Ident.label_parent), (identifier :> Identifier.LabelParent.t))
        :: map.label_parents;
      parents =
        ((id :> Ident.parent), (identifier :> Identifier.Parent.t))
        :: map.parents;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and module_ parent map id =
    let identifier =
      `Module (parent, ModuleName.of_string (Ident.Name.module_ id))
    in
    {
      map with
      module_ = (id, identifier) :: map.module_;
      signatures =
        ((id :> Ident.signature), (identifier :> Identifier.Signature.t))
        :: map.signatures;
      label_parents =
        ((id :> Ident.label_parent), (identifier :> Identifier.LabelParent.t))
        :: map.label_parents;
      parents =
        ((id :> Ident.parent), (identifier :> Identifier.Parent.t))
        :: map.parents;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and module_type parent map id =
    let identifier =
      `ModuleType (parent, ModuleTypeName.of_string (Ident.Name.module_type id))
    in
    {
      map with
      module_type = (id, identifier) :: map.module_type;
      signatures =
        ((id :> Ident.signature), (identifier :> Identifier.Signature.t))
        :: map.signatures;
      label_parents =
        ((id :> Ident.label_parent), (identifier :> Identifier.LabelParent.t))
        :: map.label_parents;
      parents =
        ((id :> Ident.parent), (identifier :> Identifier.Parent.t))
        :: map.parents;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and value_ parent map id =
    let identifier =
      `Value (parent, ValueName.of_string (Ident.Name.value id))
    in
    {
      map with
      value_ = (id, identifier) :: map.value_;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and class_ parent map id =
    let identifier =
      `Class (parent, ClassName.of_string (Ident.Name.class_ id))
    in
    {
      map with
      class_ = (id, identifier) :: map.class_;
      path_class_type =
        ((id :> Ident.path_class_type), identifier) :: map.path_class_type;
      path_type = ((id :> Ident.path_type), identifier) :: map.path_type;
      label_parents =
        ((id :> Ident.label_parent), (identifier :> Identifier.LabelParent.t))
        :: map.label_parents;
      parents =
        ((id :> Ident.parent), (identifier :> Identifier.Parent.t))
        :: map.parents;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and class_type parent map (id : Ident.class_type) =
    let identifier =
      `ClassType (parent, ClassTypeName.of_string (Ident.Name.class_type id))
    in
    {
      map with
      class_type = ((id :> Ident.class_type), identifier) :: map.class_type;
      path_class_type =
        ((id :> Ident.path_class_type), identifier) :: map.path_class_type;
      path_type = ((id :> Ident.path_type), identifier) :: map.path_type;
      label_parents =
        ((id :> Ident.label_parent), (identifier :> Identifier.LabelParent.t))
        :: map.label_parents;
      parents =
        ((id :> Ident.parent), (identifier :> Identifier.Parent.t))
        :: map.parents;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and include_ parent map i = signature parent map i.Include.expansion_

  and docs parent map d =
    List.fold_right
      (fun item map ->
        match item with
        | `Heading (_, id, _) ->
            let identifier =
              `Label (parent, LabelName.of_string (Ident.Name.label id))
            in
            { map with labels = (id, identifier) :: map.labels }
        | _ -> map)
      d map

  and docs_or_stop parent map = function
    | `Docs d -> docs parent map d
    | `Stop -> map

  and method_ parent map id =
    let identifier =
      `Method (parent, MethodName.of_string (Ident.Name.method_ id))
    in
    {
      map with
      method_ = (id, identifier) :: map.method_;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and instance_variable parent map id =
    let identifier =
      `InstanceVariable
        ( parent,
          InstanceVariableName.of_string (Ident.Name.instance_variable id) )
    in
    {
      map with
      instance_variable = (id, identifier) :: map.instance_variable;
      any = ((id :> Ident.any), (identifier :> Identifier.t)) :: map.any;
    }

  and class_signature parent map sg =
    let open ClassSignature in
    List.fold_right
      (fun item map ->
        match item with
        | Method (id, _) -> method_ parent map id
        | InstanceVariable (id, _) -> instance_variable parent map id
        | Inherit _ -> map
        | Constraint _ -> map
        | Comment c -> docs_or_stop (parent :> Identifier.LabelParent.t) map c)
      sg map

  and signature_items parent map items =
    let open Signature in
    let lpp = (parent :> Identifier.LabelParent.t) in
    List.fold_right
      (fun item map ->
        match item with
        | Module (id, _, m) ->
            let m = Subst.Delayed.get_module m in
            docs lpp (module_ parent map id) m.doc
        | ModuleSubstitution (id, m) -> docs lpp (module_ parent map id) m.doc
        | ModuleType (id, mt) ->
            let mt = Subst.Delayed.get_module_type mt in
            docs lpp (module_type parent map id) mt.doc
        | Type (id, _, t) -> docs lpp (type_decl parent map id) t.doc
        | TypeSubstitution (id, t) -> docs lpp (type_decl parent map id) t.doc
        | Exception (id, e) -> docs lpp (exception_ parent map id) e.doc
        | Value (id, v) -> docs lpp (value_ parent map id) v.doc
        | External (id, e) ->
            docs lpp (value_ parent map id) e.doc (* externals are values *)
        | Class (id, _, c) -> docs lpp (class_ parent map id) c.doc
        | ClassType (id, _, c) -> docs lpp (class_type parent map id) c.doc
        | Include i -> include_ parent map i
        | TypExt t -> docs lpp map t.doc
        | Comment d -> docs_or_stop (parent :> Identifier.LabelParent.t) map d)
      items map

  and signature parent map sg =
    let open Signature in
    signature_items parent map sg.items
end

let rec signature_items id map items =
  let open Component.Signature in
  let map = ExtractIDs.signature_items id map items in
  List.fold_right
    (fun item acc ->
      match item with
      | Module (id, r, m) ->
          let m = Subst.Delayed.get_module m in
          Odoc_model.Lang.Signature.Module (r, module_ map id m) :: acc
      | ModuleType (id, m) ->
          Odoc_model.Lang.Signature.ModuleType (module_type map id m) :: acc
      | Type (id, r, t) -> (
          try Odoc_model.Lang.Signature.Type (r, type_decl map id t) :: acc
          with e ->
            let bt = Printexc.get_backtrace () in
            Format.fprintf Format.err_formatter
              "Failed (%s) during type lookup: %a\nbt:\n%s\n%!"
              (Printexc.to_string e) Ident.fmt id bt;
            raise e )
      | Exception (id', e) ->
          Odoc_model.Lang.Signature.Exception
            (exception_ map
               (id :> Odoc_model.Paths_types.Identifier.parent)
               id' e)
          :: acc
      | TypExt t -> Odoc_model.Lang.Signature.TypExt (typ_ext map id t) :: acc
      | Value (id, v) ->
          Odoc_model.Lang.Signature.Value (value_ map id v) :: acc
      | Include i -> (
          try Odoc_model.Lang.Signature.Include (include_ id map i) :: acc
          with e ->
            Format.fprintf Format.err_formatter
              "Caught exception %s with include: %a" (Printexc.to_string e)
              Component.Fmt.include_ i;
            raise e )
      | External (id, e) ->
          Odoc_model.Lang.Signature.External (external_ map id e) :: acc
      | ModuleSubstitution (id, m) ->
          Odoc_model.Lang.Signature.ModuleSubstitution
            (module_substitution map id m)
          :: acc
      | TypeSubstitution (id, t) ->
          Odoc_model.Lang.Signature.TypeSubstitution (type_decl map id t) :: acc
      | Class (id, r, c) ->
          Odoc_model.Lang.Signature.Class (r, class_ map id c) :: acc
      | ClassType _ -> acc
      | Comment c ->
          Odoc_model.Lang.Signature.Comment (docs_or_stop map c) :: acc)
    items []

and signature id map sg =
  let open Component.Signature in
  signature_items id map sg.items

and class_ map id c =
  let open Component.Class in
  let identifier = List.assoc id map.class_ in
  let expansion =
    Opt.map
      (class_signature map (identifier :> Identifier.ClassSignature.t))
      c.expansion
  in
  {
    id = identifier;
    doc = docs map c.doc;
    virtual_ = c.virtual_;
    params = c.params;
    type_ =
      class_decl map
        (identifier :> Paths_types.Identifier.path_class_type)
        c.type_;
    expansion;
  }

and class_decl map parent c =
  match c with
  | Component.Class.ClassType expr ->
      ClassType (class_type_expr map parent expr)
  | Arrow (lbl, t, d) -> Arrow (lbl, type_expr map t, class_decl map parent d)

and class_type_expr map parent c =
  match c with
  | Component.ClassType.Constr (p, ts) ->
      Constr (Path.class_type map p, List.map (type_expr map) ts)
  | Signature s -> Signature (class_signature map parent s)

and class_type map id c =
  let open Component.ClassType in
  let identifier = List.assoc id map.class_type in
  let expansion =
    Opt.map
      (class_signature map (identifier :> Identifier.ClassSignature.t))
      c.expansion
  in
  {
    Odoc_model.Lang.ClassType.id = identifier;
    doc = docs map c.doc;
    virtual_ = c.virtual_;
    params = c.params;
    expr =
      class_type_expr map
        (identifier :> Paths_types.Identifier.path_class_type)
        c.expr;
    expansion;
  }

and class_signature map parent sg =
  let open Component.ClassSignature in
  let map = ExtractIDs.class_signature parent map sg.items in
  let items =
    List.map
      (function
        | Method (id, m) ->
            Odoc_model.Lang.ClassSignature.Method (method_ map id m)
        | InstanceVariable (id, i) ->
            InstanceVariable (instance_variable map id i)
        | Constraint (t1, t2) -> Constraint (type_expr map t1, type_expr map t2)
        | Inherit e -> Inherit (class_type_expr map parent e)
        | Comment c -> Comment (docs_or_stop map c))
      sg.items
  in
  { self = Opt.map (type_expr map) sg.self; items }

and method_ map id m =
  let open Component.Method in
  let identifier = List.assoc id map.method_ in
  {
    id = identifier;
    doc = docs map m.doc;
    private_ = m.private_;
    virtual_ = m.virtual_;
    type_ = type_expr map m.type_;
  }

and instance_variable map id i =
  let open Component.InstanceVariable in
  let identifier = List.assoc id map.instance_variable in
  {
    id = identifier;
    doc = docs map i.doc;
    mutable_ = i.mutable_;
    virtual_ = i.virtual_;
    type_ = type_expr map i.type_;
  }

and external_ map id e =
  let open Component.External in
  let identifier = List.assoc id map.value_ in
  {
    id = identifier;
    doc = docs map e.doc;
    type_ = type_expr map e.type_;
    primitives = e.primitives;
  }

and module_expansion :
    maps ->
    Identifier.Signature.t ->
    Component.Module.expansion ->
    Lang.Module.expansion =
 fun map id e ->
  let open Component.Module in
  match e with
  | AlreadyASig -> Lang.Module.AlreadyASig
  | Signature sg -> Signature (signature id map sg)
  | Functor (args, sg) ->
      let identifier, args, map =
        List.fold_right
          (fun arg (id, args, map) ->
            match arg with
            | Some arg ->
                let identifier' =
                  `Parameter
                    ( id,
                      Odoc_model.Names.ParameterName.of_string
                        (Ident.Name.module_ arg.Component.FunctorArgument.id) )
                in
                let identifier_result = `Result id in
                let map =
                  { map with module_ = (arg.id, identifier') :: map.module_ }
                in
                let arg = functor_argument map arg in
                (identifier_result, Some arg :: args, map)
            | None -> (`Result id, None :: args, map))
          args (id, [], map)
      in
      Functor (args, signature identifier map sg)

and include_ parent map i =
  let open Component.Include in
  {
    Odoc_model.Lang.Include.parent;
    doc = docs map i.doc;
    decl = module_decl map parent i.decl;
    expansion =
      { resolved = false; content = signature parent map i.expansion_ };
  }

and value_ map id v =
  let open Component.Value in
  let identifier = List.assoc id map.value_ in
  { id = identifier; doc = docs map v.doc; type_ = type_expr map v.type_ }

and typ_ext map parent t =
  let open Component.Extension in
  {
    type_path = Path.type_ map t.type_path;
    doc = docs map t.doc;
    type_params = t.type_params;
    private_ = t.private_;
    constructors = List.map (extension_constructor map parent) t.constructors;
  }

and extension_constructor map parent c =
  let open Component.Extension.Constructor in
  let identifier = `Extension (parent, c.name) in
  {
    id = identifier;
    doc = docs map c.doc;
    args =
      type_decl_constructor_argument map
        (parent :> Odoc_model.Paths_types.Identifier.parent)
        c.args;
    res = Opt.map (type_expr map) c.res;
  }

and module_ map id m =
  try
    let open Component.Module in
    let identifier =
      (List.assoc id map.module_ :> Odoc_model.Paths_types.Identifier.signature)
    in
    let canonical = function
      | Some (p, r) -> Some (Path.module_ map p, r)
      | None -> None
    in
    let expansion =
      Opt.map
        (module_expansion map (identifier :> Identifier.Signature.t))
        m.expansion
    in
    {
      Odoc_model.Lang.Module.id = List.assoc id map.module_;
      doc = docs map m.doc;
      type_ =
        module_decl map
          (identifier :> Odoc_model.Paths_types.Identifier.signature)
          m.type_;
      canonical = canonical m.canonical;
      hidden = m.hidden;
      display_type = Opt.map (module_decl map identifier) m.display_type;
      expansion;
    }
  with e ->
    let bt = Printexc.get_backtrace () in
    Format.fprintf Format.err_formatter
      "Exception handling module: %a\nbacktrace:\n%s\n%!" Ident.fmt id bt;
    raise e

and module_substitution map id m =
  let open Component.ModuleSubstitution in
  {
    Odoc_model.Lang.ModuleSubstitution.id = List.assoc id map.module_;
    doc = docs map m.doc;
    manifest = Path.module_ map m.manifest;
  }

and module_decl :
    maps ->
    Odoc_model.Paths_types.Identifier.signature ->
    Component.Module.decl ->
    Odoc_model.Lang.Module.decl =
 fun map identifier d ->
  match d with
  | Component.Module.Alias p ->
      Odoc_model.Lang.Module.Alias (Path.module_ map p)
  | ModuleType mty -> ModuleType (module_type_expr map identifier mty)

and module_type_expr map identifier =
  let substitution = function
    | Component.ModuleType.ModuleEq (frag, decl) ->
        Odoc_model.Lang.ModuleType.ModuleEq
          (frag, module_decl map identifier decl)
    | ModuleSubst (frag, path) -> ModuleSubst (frag, Path.module_ map path)
    | TypeEq (frag, eqn) -> TypeEq (frag, type_decl_equation map eqn)
    | TypeSubst (frag, eqn) -> TypeSubst (frag, type_decl_equation map eqn)
  in
  function
  | Component.ModuleType.Path p ->
      Odoc_model.Lang.ModuleType.Path (Path.module_type map p)
  | Signature s ->
      Signature
        (signature
           (identifier :> Odoc_model.Paths.Identifier.Signature.t)
           map s)
  | With (expr, subs) ->
      With (module_type_expr map identifier expr, List.map substitution subs)
  | Functor (Some arg, expr) ->
      let identifier' =
        `Parameter
          ( identifier,
            Odoc_model.Names.ParameterName.of_string (Ident.Name.module_ arg.id)
          )
      in
      let map = { map with module_ = (arg.id, identifier') :: map.module_ } in
      Functor
        ( Some (functor_argument map arg),
          module_type_expr map (`Result identifier) expr )
  | Functor (None, expr) ->
      Functor (None, module_type_expr map (`Result identifier) expr)
  | TypeOf decl -> TypeOf (module_decl map identifier decl)

and module_type map id mty =
  let mty = Subst.Delayed.get_module_type mty in
  let identifier = List.assoc id map.module_type in
  let sig_id = (identifier :> Odoc_model.Paths.Identifier.Signature.t) in
  let expansion = Opt.map (module_expansion map sig_id) mty.expansion in
  {
    Odoc_model.Lang.ModuleType.id = identifier;
    doc = docs map mty.doc;
    expr = Opt.map (module_type_expr map sig_id) mty.expr;
    display_expr = None;
    expansion;
  }

and type_decl_constructor_argument :
    maps ->
    Paths_types.Identifier.parent ->
    Component.TypeDecl.Constructor.argument ->
    Odoc_model.Lang.TypeDecl.Constructor.argument =
 fun map parent a ->
  match a with
  | Tuple ls -> Tuple (List.map (type_expr map) ls)
  | Record fs -> Record (List.map (type_decl_field map parent) fs)

and type_decl_field :
    maps ->
    Paths_types.Identifier.parent ->
    Component.TypeDecl.Field.t ->
    Odoc_model.Lang.TypeDecl.Field.t =
 fun map parent f ->
  let identifier = `Field (parent, f.name) in
  {
    id = identifier;
    doc = docs map f.doc;
    mutable_ = f.mutable_;
    type_ = type_expr map f.type_;
  }

and type_decl_equation map (eqn : Component.TypeDecl.Equation.t) :
    Odoc_model.Lang.TypeDecl.Equation.t =
  {
    params = eqn.params;
    private_ = eqn.private_;
    manifest = Opt.map (type_expr map) eqn.manifest;
    constraints =
      List.map
        (fun (x, y) -> (type_expr map x, type_expr map y))
        eqn.constraints;
  }

and type_decl map id (t : Component.TypeDecl.t) : Odoc_model.Lang.TypeDecl.t =
  let identifier = List.assoc id map.type_ in
  {
    id = identifier;
    equation = type_decl_equation map t.equation;
    doc = docs map t.doc;
    representation =
      Opt.map (type_decl_representation map identifier) t.representation;
  }

and type_decl_representation map id (t : Component.TypeDecl.Representation.t) :
    Odoc_model.Lang.TypeDecl.Representation.t =
  match t with
  | Extensible -> Extensible
  | Variant cs -> Variant (List.map (type_decl_constructor map id) cs)
  | Record fs ->
      Record
        (List.map
           (type_decl_field map
              (id :> Odoc_model.Paths_types.Identifier.parent))
           fs)

and type_decl_constructor :
    maps ->
    Odoc_model.Paths_types.Identifier.type_ ->
    Component.TypeDecl.Constructor.t ->
    Odoc_model.Lang.TypeDecl.Constructor.t =
 fun map id t ->
  let identifier = `Constructor (id, t.name) in
  {
    id = identifier;
    doc = docs map t.doc;
    args =
      type_decl_constructor_argument map
        (id :> Odoc_model.Paths_types.Identifier.parent)
        t.args;
    res = Opt.map (type_expr map) t.res;
  }

and type_expr_package map t =
  {
    Lang.TypeExpr.Package.path =
      Path.module_type map t.Component.TypeExpr.Package.path;
    substitutions =
      List.map
        (fun (frag, texpr) -> (frag, type_expr map texpr))
        t.substitutions;
  }

and type_expr map (t : Component.TypeExpr.t) : Odoc_model.Lang.TypeExpr.t =
  try
    match t with
    | Var s -> Var s
    | Any -> Any
    | Alias (t, str) -> Alias (type_expr map t, str)
    | Arrow (lbl, t1, t2) -> Arrow (lbl, type_expr map t1, type_expr map t2)
    | Tuple ts -> Tuple (List.map (type_expr map) ts)
    | Constr (path, ts) ->
        Constr (Path.type_ map path, List.map (type_expr map) ts)
    | Polymorphic_variant v -> Polymorphic_variant (type_expr_polyvar map v)
    | Object o -> Object (type_expr_object map o)
    | Class (p, ts) -> Class (Path.class_type map p, List.map (type_expr map) ts)
    | Poly (strs, t) -> Poly (strs, type_expr map t)
    | Package p -> Package (type_expr_package map p)
  with e ->
    let bt = Printexc.get_backtrace () in
    Format.fprintf Format.err_formatter
      "Exception %s handling type_expr: %a\nbacktrace:\n%s\n%!"
      (Printexc.to_string e) Component.Fmt.type_expr t bt;
    raise e

and type_expr_polyvar map v =
  let constructor c =
    {
      Lang.TypeExpr.Polymorphic_variant.Constructor.name =
        c.Component.TypeExpr.Polymorphic_variant.Constructor.name;
      constant = c.constant;
      arguments = List.map (type_expr map) c.arguments;
      doc = docs map c.doc;
    }
  in
  let element = function
    | Component.TypeExpr.Polymorphic_variant.Type t ->
        Lang.TypeExpr.Polymorphic_variant.Type (type_expr map t)
    | Constructor c -> Constructor (constructor c)
  in
  { kind = v.kind; elements = List.map element v.elements }

and type_expr_object map o =
  let method_ m =
    {
      Lang.TypeExpr.Object.name = m.Component.TypeExpr.Object.name;
      type_ = type_expr map m.type_;
    }
  in
  let field = function
    | Component.TypeExpr.Object.Method m ->
        Lang.TypeExpr.Object.Method (method_ m)
    | Inherit i -> Inherit (type_expr map i)
  in
  { Lang.TypeExpr.Object.fields = List.map field o.fields; open_ = o.open_ }

and functor_argument map f =
  let identifier = List.assoc f.id map.module_ in
  let expansion =
    Opt.map
      (module_expansion map (identifier :> Identifier.Signature.t))
      f.expansion
  in
  {
    Odoc_model.Lang.FunctorArgument.id = identifier;
    expr =
      module_type_expr map
        (identifier :> Odoc_model.Paths_types.Identifier.signature)
        f.expr;
    expansion;
  }

and exception_ map parent id (e : Component.Exception.t) :
    Odoc_model.Lang.Exception.t =
  let identifier = List.assoc id map.exception_ in
  {
    id = identifier;
    doc = docs map e.doc;
    args = type_decl_constructor_argument map parent e.args;
    res = Opt.map (type_expr map) e.res;
  }

and location : 'a. 'a -> 'a Location_.with_location =
 fun value ->
  {
    Location_.value;
    location =
      {
        file = "";
        start = { line = 0; column = 0 };
        end_ = { line = 0; column = 0 };
      };
  }

and with_location :
      'a 'b. (maps -> 'a -> 'b) -> maps -> 'a -> 'b Location_.with_location =
 fun conv ident_map v -> location (conv ident_map v)

and already_with_location :
    (maps -> 'a -> 'b) ->
    maps ->
    'a Location_.with_location ->
    'b Location_.with_location =
 fun conv ident_map v -> location (conv ident_map v.Location_.value)

and inline_element :
    maps -> Component.CComment.inline_element -> Comment.inline_element =
 fun map t ->
  match t with
  | #Odoc_model.Comment.leaf_inline_element as n -> n
  | `Reference (r, c) -> `Reference (Path.reference map r, c)
  | `Styled (x, y) ->
      `Styled (x, List.map (already_with_location inline_element map) y)
  | `Link (x, y) -> `Link (x, y)

and nestable_block_element :
    maps ->
    Component.CComment.nestable_block_element ->
    Comment.nestable_block_element =
 fun map t ->
  match t with
  | `Paragraph xs ->
      `Paragraph (List.map (fun x -> location (inline_element map x)) xs)
  | `Code_block s -> `Code_block s
  | `Verbatim s -> `Verbatim s
  | `Modules rs -> `Modules (List.map (Path.module_reference map) rs)
  | `List (x, yss) ->
      `List
        (x, List.map (List.map (with_location nestable_block_element map)) yss)

and tag map t =
  let nbe = List.map (with_location nestable_block_element map) in
  match t with
  | `Author s -> `Author s
  | `Deprecated ds -> `Deprecated (nbe ds)
  | `Param (s, ds) -> `Param (s, nbe ds)
  | `Raise (s, ds) -> `Raise (s, nbe ds)
  | `Return ds -> `Return (nbe ds)
  | `See (x, y, z) -> `See (x, y, nbe z)
  | `Since s -> `Since s
  | `Before (x, ys) -> `Before (x, nbe ys)
  | `Version s -> `Version s
  | `Canonical (p, r) ->
      `Canonical (Path.module_ map p, Path.module_reference map r)
  | `Inline -> `Inline
  | `Open -> `Open
  | `Closed -> `Closed

and block_element map (d : Component.CComment.block_element) :
    Odoc_model.Comment.block_element =
  match d with
  | `Heading (l, id, content) -> (
      try `Heading (l, List.assoc id map.labels, content)
      with Not_found ->
        Format.fprintf Format.err_formatter "Failed to find id: %a\n" Ident.fmt
          id;
        raise Not_found )
  | `Tag t -> `Tag (tag map t)
  | #Component.CComment.nestable_block_element as n ->
      (nestable_block_element map n :> Odoc_model.Comment.block_element)

and docs : maps -> Component.CComment.docs -> Odoc_model.Comment.docs =
 fun map ds -> List.map (fun d -> location (block_element map d)) ds

and docs_or_stop map (d : Component.CComment.docs_or_stop) =
  match d with `Docs d -> `Docs (docs map d) | `Stop -> `Stop
