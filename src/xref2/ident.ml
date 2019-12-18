open Odoc_model.Names
open Odoc_model.Paths

(* For simplicity keep a global counter *)
let counter = ref 0

type signature =
  [ `LRoot of UnitName.t * int
  | `LModule of ModuleName.t * int
  | `LResult of signature
  | `LParameter of ParameterName.t * int
  | `LModuleType of ModuleTypeName.t * int ]

type class_signature =
  [ `LClass of ClassName.t * int | `LClassType of ClassTypeName.t * int ]

type datatype = [ `LType of TypeName.t * int | `LCoreType of TypeName.t ]

type parent = [ signature | datatype | class_signature ]

type label_parent = [ parent | `LPage of PageName.t * int ]

type module_ =
  [ `LRoot of UnitName.t * int
  | `LModule of ModuleName.t * int
  | `LResult of signature
  | `LParameter of ParameterName.t * int ]

type module_type = [ `LModuleType of ModuleTypeName.t * int ]

type type_ = datatype

type constructor = [ `LConstructor of ConstructorName.t * int ]

type field = [ `LField of FieldName.t * int ]

type extension = [ `LExtension of ExtensionName.t * int ]

type exception_ =
  [ `LException of ExceptionName.t * int | `LCoreException of ExceptionName.t ]

type value = [ `LValue of ValueName.t * int ]

type class_ = [ `LClass of ClassName.t * int ]

type class_type = [ `LClassType of ClassTypeName.t * int ]

type path_type = [ type_ | class_ | class_type ]

type path_class_type = [ class_ | class_type ]

type method_ = [ `LMethod of MethodName.t * int ]

type instance_variable = [ `LInstanceVariable of InstanceVariableName.t * int ]

type label = [ `LLabel of LabelName.t * int ]

type page = [ `LPage of PageName.t * int ]

type any =
  [ signature
  | class_signature
  | datatype
  | parent
  | label_parent
  | module_
  | module_type
  | type_
  | constructor
  | field
  | extension
  | exception_
  | value
  | class_
  | class_type
  | method_
  | instance_variable
  | label
  | page ]

let fresh_int () =
  let n = !counter in
  incr counter;
  n

module Of_Identifier = struct
  open Identifier

  let rec signature : Signature.t -> signature =
   fun sg ->
    let i = fresh_int () in
    match sg with
    | `Root (_, n) -> `LRoot (n, i)
    | `Module (_, n) -> `LModule (n, i)
    | `Parameter (_, n) -> `LParameter (n, i)
    | `ModuleType (_, n) -> `LModuleType (n, i)
    | `Result sg -> `LResult (signature sg)

  let class_signature : ClassSignature.t -> class_signature =
   fun sg ->
    let i = fresh_int () in
    match sg with
    | `Class (_, n) -> `LClass (n, i)
    | `ClassType (_, n) -> `LClassType (n, i)

  let datatype : DataType.t -> datatype =
   fun t ->
    let i = fresh_int () in
    match t with `Type (_, n) -> `LType (n, i) | `CoreType n -> `LCoreType n

  let parent : Parent.t -> parent =
   fun p ->
    match p with
    | #Signature.t as s -> (signature s :> parent)
    | #DataType.t as s -> (datatype s :> parent)
    | #ClassSignature.t as s -> (class_signature s :> parent)

  let label_parent : LabelParent.t -> label_parent =
   fun p ->
    match p with
    | #Parent.t as s -> (parent s :> label_parent)
    | `Page (_, n) -> `LPage (n, fresh_int ())

  let module_ : Module.t -> module_ =
   fun m ->
    let i = fresh_int () in
    match m with
    | `Root (_, n) -> `LRoot (n, i)
    | `Module (_, n) -> `LModule (n, i)
    | `Parameter (_, n) -> `LParameter (n, i)
    | `Result x -> `LResult (signature x)

  let module_type : ModuleType.t -> module_type =
   fun m ->
    let i = fresh_int () in
    match m with `ModuleType (_, n) -> `LModuleType (n, i)

  let type_ : Type.t -> type_ = datatype

  let constructor : Constructor.t -> constructor =
   fun c -> match c with `Constructor (_, n) -> `LConstructor (n, fresh_int ())

  let field : Field.t -> field =
   fun f -> match f with `Field (_, n) -> `LField (n, fresh_int ())

  let extension : Extension.t -> extension =
   fun e -> match e with `Extension (_, n) -> `LExtension (n, fresh_int ())

  let exception_ : Exception.t -> exception_ =
   fun e ->
    match e with
    | `Exception (_, n) -> `LException (n, fresh_int ())
    | `CoreException n -> `LCoreException n

  let value : Value.t -> value =
   fun v -> match v with `Value (_, n) -> `LValue (n, fresh_int ())

  let class_ : Class.t -> class_ =
   fun c -> match c with `Class (_, n) -> `LClass (n, fresh_int ())

  let class_type : ClassType.t -> class_type =
   fun c -> match c with `ClassType (_, n) -> `LClassType (n, fresh_int ())

  let method_ : Method.t -> method_ =
   fun c -> match c with `Method (_, n) -> `LMethod (n, fresh_int ())

  let instance_variable : InstanceVariable.t -> instance_variable =
   fun i ->
    match i with
    | `InstanceVariable (_, n) -> `LInstanceVariable (n, fresh_int ())

  let label : Label.t -> label =
   fun l -> match l with `Label (_, n) -> `LLabel (n, fresh_int ())

  let page : Page.t -> page =
   fun p -> match p with `Page (_, n) -> `LPage (n, fresh_int ())
end

module Name = struct
  let rec signature : signature -> string = function
    | `LRoot (n, _) -> UnitName.to_string n
    | `LModule (n, _) -> ModuleName.to_string n
    | `LResult x -> signature x
    | `LParameter (n, _) -> ParameterName.to_string n
    | `LModuleType (n, _) -> ModuleTypeName.to_string n

  let module_ : module_ -> string = function
    | `LRoot (n, _) -> UnitName.to_string n
    | `LModule (n, _) -> ModuleName.to_string n
    | `LResult x -> signature x
    | `LParameter (n, _) -> ParameterName.to_string n

  let type_ : type_ -> string = function
    | `LType (n, _) -> TypeName.to_string n
    | `LCoreType n -> TypeName.to_string n

  let path_type : path_type -> string = function
    | `LClassType (n, _) -> ClassTypeName.to_string n
    | `LClass (n, _) -> ClassName.to_string n
    | `LType (n, _) -> TypeName.to_string n
    | `LCoreType n -> TypeName.to_string n

  let class_ : class_ -> string = function
    | `LClass (n, _) -> ClassName.to_string n

  let module_type : module_type -> string = function
    | `LModuleType (n, _) -> ModuleTypeName.to_string n

  let path_class_type : path_class_type -> string = function
    | `LClass (n, _) -> ClassName.to_string n
    | `LClassType (n, _) -> ClassTypeName.to_string n

  let class_type : class_type -> string = function
    | `LClassType (n, _) -> ClassTypeName.to_string n

  let exception_ : exception_ -> string = function
    | `LCoreException n | `LException (n, _) -> ExceptionName.to_string n

  let value : value -> string = function
    | `LValue (n, _) -> ValueName.to_string n

  let label : label -> string = function
    | `LLabel (n, _) -> LabelName.to_string n

  let method_ : method_ -> string = function
    | `LMethod (n, _) -> MethodName.to_string n

  let instance_variable : instance_variable -> string = function
    | `LInstanceVariable (n, _) -> InstanceVariableName.to_string n
end

module Rename = struct
  let rec signature : signature -> signature = function
    | `LRoot (n, _) -> `LRoot (n, fresh_int ())
    | `LModule (n, _) -> `LModule (n, fresh_int ())
    | `LResult x -> `LResult (signature x)
    | `LParameter (n, _) -> `LParameter (n, fresh_int ())
    | `LModuleType (n, _) -> `LModuleType (n, fresh_int ())

  let module_ : module_ -> module_ = function
    | `LRoot (n, _) -> `LRoot (n, fresh_int ())
    | `LModule (n, _) -> `LModule (n, fresh_int ())
    | `LResult x -> `LResult (signature x)
    | `LParameter (n, _) -> `LParameter (n, fresh_int ())

  let module_type : module_type -> module_type = function
    | `LModuleType (n, _) -> `LModuleType (n, fresh_int ())

  let type_ : type_ -> type_ = function
    | `LType (n, _) -> `LType (n, fresh_int ())
    | `LCoreType _ as y -> y

  let exception_ : exception_ -> exception_ = function
    | `LException (n, _) -> `LException (n, fresh_int ())
    | `LCoreException _ as y -> y

  let value : value -> value = function
    | `LValue (n, _) -> `LValue (n, fresh_int ())

  let class_ : class_ -> class_ = function
    | `LClass (n, _) -> `LClass (n, fresh_int ())

  let class_type : class_type -> class_type = function
    | `LClassType (n, _) -> `LClassType (n, fresh_int ())
end

let reset () = counter := 0

let rec fmt_aux ppf (id : any) =
  match id with
  | `LRoot (n, i) -> Format.fprintf ppf "%s/%d" (UnitName.to_string n) i
  | `LModule (n, i) -> Format.fprintf ppf "%s/%d" (ModuleName.to_string n) i
  | `LParameter (n, i) ->
      Format.fprintf ppf "%s/%d" (ParameterName.to_string n) i
  | `LResult x -> Format.fprintf ppf "result(%a)" fmt_aux (x :> any)
  | `LModuleType (n, i) ->
      Format.fprintf ppf "%s/%d" (ModuleTypeName.to_string n) i
  | `LType (n, i) -> Format.fprintf ppf "%s/%d" (TypeName.to_string n) i
  | `LCoreType n -> Format.fprintf ppf "%s" (TypeName.to_string n)
  | `LConstructor (n, i) ->
      Format.fprintf ppf "%s/%d" (ConstructorName.to_string n) i
  | `LField (n, i) -> Format.fprintf ppf "%s/%d" (FieldName.to_string n) i
  | `LExtension (n, i) ->
      Format.fprintf ppf "%s/%d" (ExtensionName.to_string n) i
  | `LException (n, i) ->
      Format.fprintf ppf "%s/%d" (ExceptionName.to_string n) i
  | `LCoreException n -> Format.fprintf ppf "%s" (ExceptionName.to_string n)
  | `LValue (n, i) -> Format.fprintf ppf "%s/%d" (ValueName.to_string n) i
  | `LClass (n, i) -> Format.fprintf ppf "%s/%d" (ClassName.to_string n) i
  | `LClassType (n, i) ->
      Format.fprintf ppf "%s/%d" (ClassTypeName.to_string n) i
  | `LMethod (n, i) -> Format.fprintf ppf "%s/%d" (MethodName.to_string n) i
  | `LInstanceVariable (n, i) ->
      Format.fprintf ppf "%s/%d" (InstanceVariableName.to_string n) i
  | `LLabel (n, i) -> Format.fprintf ppf "%s/%d" (LabelName.to_string n) i
  | `LPage (n, i) -> Format.fprintf ppf "%s/%d" (PageName.to_string n) i

let fmt : Format.formatter -> [< any ] -> unit =
 fun ppf id -> fmt_aux ppf (id :> any)

let rename (s, _) = (s, fresh_int ())
