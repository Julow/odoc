(*
 * Copyright (c) 2014 Leo White <lpw25@cl.cam.ac.uk>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

open Lang_types
open Paths

(** {3 Modules} *)

module Module = struct
  type expansion = module_expansion =
    | AlreadyASig
    | Signature of signature
    | Functor of functor_parameter list * signature

  type decl = module_decl =
    | Alias of Path.Module.t
    | ModuleType of moduletype_expr

  type t = module_ = {
    id : Identifier.Module.t;
    doc : Comment.docs;
    type_ : module_decl;
    canonical : (Path.Module.t * Reference.Module.t) option;
    hidden : bool;
    display_type : module_decl option;
    expansion : module_expansion option;
  }

  module Equation = struct
    type t = module_equation
  end
end

module FunctorParameter = struct
  type parameter = functor_parameter_named = {
    id : Identifier.FunctorParameter.t;
    expr : moduletype_expr;
    display_expr : moduletype_expr option;
    expansion : module_expansion option;
  }

  type t = functor_parameter = Unit | Named of functor_parameter_named
end

(** {3 Modules Types} *)

module ModuleType = struct
  type substitution = moduletype_substitution =
    | ModuleEq of Fragment.Module.t * module_equation
    | TypeEq of Fragment.Type.t * typedecl_equation
    | ModuleSubst of Fragment.Module.t * Path.Module.t
    | TypeSubst of Fragment.Type.t * typedecl_equation

  type type_of_desc = moduletype_type_of_desc =
    | MPath of Path.Module.t
    | Struct_include of Path.Module.t

  type expr = moduletype_expr =
    | Path of Path.ModuleType.t
    | Signature of signature
    | Functor of functor_parameter * moduletype_expr
    | With of moduletype_expr * moduletype_substitution list
    | TypeOf of moduletype_type_of_desc

  type t = moduletype = {
    id : Identifier.ModuleType.t;
    doc : Comment.docs;
    expr : moduletype_expr option;
    display_expr : moduletype_expr option option;
    (* Optional override *)
    expansion : module_expansion option;
  }
end

module ModuleSubstitution = struct
  type t = module_substitution = {
    id : Identifier.Module.t;
    doc : Comment.docs;
    manifest : Path.Module.t;
  }
end

(** {3 Signatures} *)

module Signature = struct
  type recursive = signature_recursive = Ordinary | And | Nonrec | Rec

  type item = signature_item =
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

  type t = signature
end

module Open = struct
  type t = open_ = { expansion : signature }
end

(** {3 Includes} *)

module Include = struct
  type shadowed = include_shadowed = {
    s_modules : (string * Identifier.Module.t) list;
    s_module_types : (string * Identifier.ModuleType.t) list;
    s_types : (string * Identifier.Type.t) list;
    s_classes : (string * Identifier.Class.t) list;
    s_class_types : (string * Identifier.ClassType.t) list;
  }

  type expansion = include_expansion = {
    resolved : bool;
    shadowed : include_shadowed;
    content : signature;
  }

  type t = include_ = {
    parent : Identifier.Signature.t;
    doc : Comment.docs;
    decl : module_decl;
    inline : bool;
    expansion : include_expansion;
  }
end

(** {3 Type Declarations} *)

module TypeDecl = struct
  module Field = struct
    type t = typedecl_field = {
      id : Identifier.Field.t;
      doc : Comment.docs;
      mutable_ : bool;
      type_ : typeexpr;
    }
  end

  module Constructor = struct
    type argument = typedecl_constructor_argument =
      | Tuple of typeexpr list
      | Record of typedecl_field list

    type t = typedecl_constructor = {
      id : Identifier.Constructor.t;
      doc : Comment.docs;
      args : typedecl_constructor_argument;
      res : typeexpr option;
    }
  end

  module Representation = struct
    type t = typedecl_representation =
      | Variant of typedecl_constructor list
      | Record of typedecl_field list
      | Extensible
  end

  type variance = typedecl_variance = Pos | Neg

  type param_desc = typedecl_param_desc = Any | Var of string

  type param = typedecl_param

  module Equation = struct
    type t = typedecl_equation = {
      params : typedecl_param list;
      private_ : bool;
      manifest : typeexpr option;
      constraints : (typeexpr * typeexpr) list;
    }
  end

  type t = typedecl = {
    id : Identifier.Type.t;
    doc : Comment.docs;
    equation : typedecl_equation;
    representation : typedecl_representation option;
  }
end

(** {3 Type extensions} *)

module Extension = struct
  module Constructor = struct
    type t = typeext_constructor = {
      id : Identifier.Extension.t;
      doc : Comment.docs;
      args : typedecl_constructor_argument;
      res : typeexpr option;
    }
  end

  type t = typeext = {
    type_path : Path.Type.t;
    doc : Comment.docs;
    type_params : typedecl_param list;
    private_ : bool;
    constructors : typeext_constructor list;
  }
end

(** {3 Exception} *)

module Exception = struct
  type t = exception_ = {
    id : Identifier.Exception.t;
    doc : Comment.docs;
    args : typedecl_constructor_argument;
    res : typeexpr option;
  }
end

(** {3 Values} *)

module Value = struct
  type t = value = {
    id : Identifier.Value.t;
    doc : Comment.docs;
    type_ : typeexpr;
  }
end

(** {3 External values} *)

module External = struct
  type t = external_ = {
    id : Identifier.Value.t;
    doc : Comment.docs;
    type_ : typeexpr;
    primitives : string list;
  }
end

(** {3 Classes} *)

module Class = struct
  type decl = class_decl =
    | ClassType of classtype_expr
    | Arrow of arrow_label option * typeexpr * class_decl

  type t = class_ = {
    id : Identifier.Class.t;
    doc : Comment.docs;
    virtual_ : bool;
    params : typedecl_param list;
    type_ : class_decl;
    expansion : classsig option;
  }
end

(** {3 Class Types} *)

module ClassType = struct
  type expr = classtype_expr =
    | Constr of Path.ClassType.t * typeexpr list
    | Signature of classsig

  type t = classtype = {
    id : Identifier.ClassType.t;
    doc : Comment.docs;
    virtual_ : bool;
    params : typedecl_param list;
    expr : classtype_expr;
    expansion : classsig option;
  }
end

(** {3 Class Signatures} *)

module ClassSignature = struct
  type item = classsig_item =
    | Method of method_
    | InstanceVariable of instance_variable
    | Constraint of typeexpr * typeexpr
    | Inherit of classtype_expr
    | Comment of Comment.docs_or_stop

  type t = classsig = { self : typeexpr option; items : classsig_item list }
end

(** {3 Methods} *)

module Method = struct
  type t = method_ = {
    id : Identifier.Method.t;
    doc : Comment.docs;
    private_ : bool;
    virtual_ : bool;
    type_ : typeexpr;
  }
end

(** {3 Instance variables} *)

module InstanceVariable = struct
  type t = instance_variable = {
    id : Identifier.InstanceVariable.t;
    doc : Comment.docs;
    mutable_ : bool;
    virtual_ : bool;
    type_ : typeexpr;
  }
end

(** {3 Type expressions} *)

module TypeExpr = struct
  module Polymorphic_variant = struct
    type kind = polyvariant_kind = Fixed | Closed of string list | Open

    module Constructor = struct
      type t = polyvariant_constructor = {
        name : string;
        constant : bool;
        arguments : typeexpr list;
        doc : Comment.docs;
      }
    end

    type element = polyvariant_element =
      | Type of typeexpr
      | Constructor of polyvariant_constructor

    type t = polyvariant = {
      kind : polyvariant_kind;
      elements : polyvariant_element list;
    }
  end

  module Object = struct
    type method_ = object_method = { name : string; type_ : typeexpr }

    type field = object_field = Method of object_method | Inherit of typeexpr

    type t = object_ = { fields : object_field list; open_ : bool }
  end

  module Package = struct
    type substitution = package_substitution

    type t = package = {
      path : Path.ModuleType.t;
      substitutions : package_substitution list;
    }
  end

  type label = arrow_label = Label of string | Optional of string

  type t = typeexpr =
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
end

(** {3 Compilation units} *)

module Compilation_unit = struct
  module Import = struct
    type t = unit_import =
      | Unresolved of string * Digest.t option
      | Resolved of Root.t * Names.ModuleName.t
  end

  module Source = struct
    type t = unit_source = {
      file : string;
      build_dir : string;
      digest : Digest.t;
    }
  end

  module Packed = struct
    type item = unit_packed_item = {
      id : Identifier.Module.t;
      path : Path.Module.t;
    }

    type t = unit_packed
  end

  type content = unit_content = Module of signature | Pack of unit_packed

  type t = unit_ = {
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
end

module Page = struct
  type t = page = {
    name : Identifier.Page.t;
    content : Comment.docs;
    digest : Digest.t;
  }
end
