[@@@warning "-30"]

open Paths

(** {3 Modules} *)

type module_expansion =
  | AlreadyASig
  | Signature of signature
  | Functor of functor_parameter list * signature

and module_decl = Alias of Path.Module.t | ModuleType of moduletype_expr

and module_ = {
  id : Identifier.Module.t;
  doc : Comment.docs;
  type_ : module_decl;
  canonical : (Path.Module.t * Reference.Module.t) option;
  hidden : bool;
  display_type : module_decl option;
  expansion : module_expansion option;
}

and module_equation = module_decl

(** {3 Functor parameter} *)

and functor_parameter_named = {
  id : Identifier.FunctorParameter.t;
  expr : moduletype_expr;
  display_expr : moduletype_expr option;
  expansion : module_expansion option;
}

and functor_parameter = Unit | Named of functor_parameter_named

(** {3 Modules Types} *)

and moduletype_substitution =
  | ModuleEq of Fragment.Module.t * module_equation
  | TypeEq of Fragment.Type.t * typedecl_equation
  | ModuleSubst of Fragment.Module.t * Path.Module.t
  | TypeSubst of Fragment.Type.t * typedecl_equation

and moduletype_type_of_desc =
  | MPath of Path.Module.t
  | Struct_include of Path.Module.t

and moduletype_expr =
  | Path of Path.ModuleType.t
  | Signature of signature
  | Functor of functor_parameter * moduletype_expr
  | With of moduletype_expr * moduletype_substitution list
  | TypeOf of moduletype_type_of_desc

and moduletype = {
  id : Identifier.ModuleType.t;
  doc : Comment.docs;
  expr : moduletype_expr option;
  display_expr : moduletype_expr option option;
  (* Optional override *)
  expansion : module_expansion option;
}

(** {3 Module substitution} *)

and module_substitution = {
  id : Identifier.Module.t;
  doc : Comment.docs;
  manifest : Path.Module.t;
}

(** {3 Signatures} *)

and signature_recursive = Ordinary | And | Nonrec | Rec

and signature_item =
  | Module of signature_recursive * module_
  | ModuleType of moduletype
  | ModuleSubstitution of module_substitution
  | Open of open_
  | Type of signature_recursive * typedecl
  | TypeSubstitution of typedecl
  | TypExt of typeext
  | Exception of exception_
  | Value of value
  | External of external_
  | Class of signature_recursive * class_
  | ClassType of signature_recursive * classtype
  | Include of include_
  | Comment of Comment.docs_or_stop

and signature = signature_item list

(** {3 Open} *)

and open_ = { expansion : signature }

(** {3 Includes} *)

and include_shadowed = {
  s_modules : (string * Identifier.Module.t) list;
  s_module_types : (string * Identifier.ModuleType.t) list;
  s_types : (string * Identifier.Type.t) list;
  s_classes : (string * Identifier.Class.t) list;
  s_class_types : (string * Identifier.ClassType.t) list;
}

and include_expansion = {
  resolved : bool;
  shadowed : include_shadowed;
  content : signature;
}

and include_ = {
  parent : Identifier.Signature.t;
  doc : Comment.docs;
  decl : module_decl;
  inline : bool;
  expansion : include_expansion;
}

(** {3 Type Declarations} *)

and typedecl_field = {
  id : Identifier.Field.t;
  doc : Comment.docs;
  mutable_ : bool;
  type_ : typeexpr;
}

and typedecl_constructor_argument =
  | Tuple of typeexpr list
  | Record of typedecl_field list

and typedecl_constructor = {
  id : Identifier.Constructor.t;
  doc : Comment.docs;
  args : typedecl_constructor_argument;
  res : typeexpr option;
}

and typedecl_representation =
  | Variant of typedecl_constructor list
  | Record of typedecl_field list
  | Extensible

and typedecl_variance = Pos | Neg

and typedecl_param_desc = Any | Var of string

and typedecl_param = typedecl_param_desc * typedecl_variance option

and typedecl_equation = {
  params : typedecl_param list;
  private_ : bool;
  manifest : typeexpr option;
  constraints : (typeexpr * typeexpr) list;
}

and typedecl = {
  id : Identifier.Type.t;
  doc : Comment.docs;
  equation : typedecl_equation;
  representation : typedecl_representation option;
}

(** {3 Type extensions} *)

and typeext_constructor = {
  id : Identifier.Extension.t;
  doc : Comment.docs;
  args : typedecl_constructor_argument;
  res : typeexpr option;
}

and typeext = {
  type_path : Path.Type.t;
  doc : Comment.docs;
  type_params : typedecl_param list;
  private_ : bool;
  constructors : typeext_constructor list;
}

(** {3 Exception} *)

and exception_ = {
  id : Identifier.Exception.t;
  doc : Comment.docs;
  args : typedecl_constructor_argument;
  res : typeexpr option;
}

(** {3 Values} *)

and value = { id : Identifier.Value.t; doc : Comment.docs; type_ : typeexpr }

(** {3 External values} *)

and external_ = {
  id : Identifier.Value.t;
  doc : Comment.docs;
  type_ : typeexpr;
  primitives : string list;
}

(** {3 Classes} *)

and class_decl =
  | ClassType of classtype_expr
  | Arrow of arrow_label option * typeexpr * class_decl

and class_ = {
  id : Identifier.Class.t;
  doc : Comment.docs;
  virtual_ : bool;
  params : typedecl_param list;
  type_ : class_decl;
  expansion : classsig option;
}

(** {3 Class Types} *)

and classtype_expr =
  | Constr of Path.ClassType.t * typeexpr list
  | Signature of classsig

and classtype = {
  id : Identifier.ClassType.t;
  doc : Comment.docs;
  virtual_ : bool;
  params : typedecl_param list;
  expr : classtype_expr;
  expansion : classsig option;
}

(** {3 Class Signatures} *)

and classsig_item =
  | Method of method_
  | InstanceVariable of instance_variable
  | Constraint of typeexpr * typeexpr
  | Inherit of classtype_expr
  | Comment of Comment.docs_or_stop

and classsig = { self : typeexpr option; items : classsig_item list }

(** {3 Methods} *)

and method_ = {
  id : Identifier.Method.t;
  doc : Comment.docs;
  private_ : bool;
  virtual_ : bool;
  type_ : typeexpr;
}

(** {3 Instance variables} *)

and instance_variable = {
  id : Identifier.InstanceVariable.t;
  doc : Comment.docs;
  mutable_ : bool;
  virtual_ : bool;
  type_ : typeexpr;
}

(** {3 Type expressions} *)
(** {4 Polymorphic variant} *)

and polyvariant_kind = Fixed | Closed of string list | Open

and polyvariant_constructor = {
  name : string;
  constant : bool;
  arguments : typeexpr list;
  doc : Comment.docs;
}

and polyvariant_element =
  | Type of typeexpr
  | Constructor of polyvariant_constructor

and polyvariant = {
  kind : polyvariant_kind;
  elements : polyvariant_element list;
}

(** {4 Object} *)

and object_method = { name : string; type_ : typeexpr }

and object_field = Method of object_method | Inherit of typeexpr

and object_ = { fields : object_field list; open_ : bool }

(** {4 Package} *)

and package_substitution = Fragment.Type.t * typeexpr

and package = {
  path : Path.ModuleType.t;
  substitutions : package_substitution list;
}

(** {4 Type expression} *)
and arrow_label = Label of string | Optional of string

and typeexpr =
  | Var of string
  | Any
  | Alias of typeexpr * string
  | Arrow of arrow_label option * typeexpr * typeexpr
  | Tuple of typeexpr list
  | Constr of Path.Type.t * typeexpr list
  | Polymorphic_variant of polyvariant
  | Object of object_
  | Class of Path.ClassType.t * typeexpr list
  | Poly of string list * typeexpr
  | Package of package

(** {3 Compilation units} *)

and unit_import =
  | Unresolved of string * Digest.t option
  | Resolved of Root.t * Names.ModuleName.t

and unit_source = { file : string; build_dir : string; digest : Digest.t }

and unit_packed_item = { id : Identifier.Module.t; path : Path.Module.t }

and unit_packed = unit_packed_item list

and unit_content = Module of signature | Pack of unit_packed

and unit_ = {
  id : Identifier.RootModule.t;
  doc : Comment.docs;
  digest : Digest.t;
  imports : unit_import list;
  source : unit_source option;
  interface : bool;
  hidden : bool;
  content : unit_content;
  expansion : signature option;
}

and page = {
  name : Identifier.Page.t;
  content : Comment.docs;
  digest : Digest.t;
}
