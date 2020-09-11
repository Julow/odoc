open Odoc_model

module%gen rec Module : sig
  type expansion = [%import: Odoc_model.Lang.Module.expansion] [@@deriving show]

  type decl = [%import: Odoc_model.Lang.Module.decl] [@@deriving show]

  type t = [%import: Odoc_model.Lang.Module.t] [@@deriving show]

  module Equation : sig
    type t = [%import: Odoc_model.Lang.Module.Equation.t] [@@deriving show]
  end
end =
  Module

and FunctorParameter : sig
  type parameter = [%import: Odoc_model.Lang.FunctorParameter.parameter] [@@deriving show]

  type t = [%import: Odoc_model.Lang.FunctorParameter.t] [@@deriving show]
end =
  FunctorParameter

and ModuleType : sig
  type substitution = [%import: Odoc_model.Lang.ModuleType.substitution] [@@deriving show]

  type type_of_desc = [%import: Odoc_model.Lang.ModuleType.type_of_desc] [@@deriving show]

  type expr = [%import: Odoc_model.Lang.ModuleType.expr] [@@deriving show]

  type t = [%import: Odoc_model.Lang.ModuleType.t] [@@deriving show]
end =
  ModuleType

and ModuleSubstitution : sig
  type t = [%import: Odoc_model.Lang.ModuleSubstitution.t] [@@deriving show]
end =
  ModuleSubstitution

and Signature : sig
  type recursive = [%import: Odoc_model.Lang.Signature.recursive] [@@deriving show]

  type item = [%import: Odoc_model.Lang.Signature.item] [@@deriving show]

  type t = [%import: Odoc_model.Lang.Signature.t] [@@deriving show]
end =
  Signature

and Open : sig
  type t = [%import: Odoc_model.Lang.Open.t] [@@deriving show]
end =
  Open

and Include : sig
  type shadowed = [%import: Odoc_model.Lang.Include.shadowed] [@@deriving show]

  type expansion = [%import: Odoc_model.Lang.Include.expansion] [@@deriving show]

  type t = [%import: Odoc_model.Lang.Include.t] [@@deriving show]
end =
  Include

and TypeDecl : sig
  module Field : sig
    type t = [%import: Odoc_model.Lang.TypeDecl.Field.t] [@@deriving show]
  end

  module Constructor : sig
    type argument = [%import: Odoc_model.Lang.TypeDecl.Constructor.argument] [@@deriving show]

    type t = [%import: Odoc_model.Lang.TypeDecl.t] [@@deriving show]
  end

  module Representation : sig
    type t = [%import: Odoc_model.Lang.TypeDecl.Representation.t] [@@deriving show]
  end

  type variance = [%import: Odoc_model.Lang.TypeDecl.variance] [@@deriving show]

  type param_desc = [%import: Odoc_model.Lang.TypeDecl.param_desc] [@@deriving show]

  type param = [%import: Odoc_model.Lang.TypeDecl.param] [@@deriving show]

  module Equation : sig
    type t = [%import: Odoc_model.Lang.TypeDecl.Equation.t] [@@deriving show]
  end

  type t = [%import: Odoc_model.Lang.TypeDecl.t] [@@deriving show]
end =
  TypeDecl

and Extension : sig
  module Constructor : sig
    type t = [%import: Odoc_model.Lang.Extension.Constructor.t] [@@deriving show]
  end

  type t = [%import: Odoc_model.Lang.Extension.t] [@@deriving show]
end =
  Extension

and Exception : sig
  type t = [%import: Odoc_model.Lang.Exception.t] [@@deriving show]
end =
  Exception

and Value : sig
  type t = [%import: Odoc_model.Lang.Value.t] [@@deriving show]
end =
  Value

and External : sig
  type t = [%import: Odoc_model.Lang.External.t] [@@deriving show]
end =
  External

and Class : sig
  type decl = [%import: Odoc_model.Lang.Class.decl] [@@deriving show]

  type t = [%import: Odoc_model.Lang.Class.t] [@@deriving show]
end =
  Class

and ClassType : sig
  type expr = [%import: Odoc_model.Lang.ClassType.expr] [@@deriving show]

  type t = [%import: Odoc_model.Lang.ClassType.t] [@@deriving show]
end =
  ClassType

and ClassSignature : sig
  type item = [%import: Odoc_model.Lang.ClassSignature.item] [@@deriving show]

  type t = [%import: Odoc_model.Lang.ClassSignature.t] [@@deriving show]
end =
  ClassSignature

and Method : sig
  type t = [%import: Odoc_model.Lang.Method.t] [@@deriving show]
end =
  Method

and InstanceVariable : sig
  type t = [%import: Odoc_model.Lang.InstanceVariable.t] [@@deriving show]
end =
  InstanceVariable

and TypeExpr : sig
  module Polymorphic_variant : sig
    type kind = [%import: Odoc_model.Lang.TypeExpr.Polymorphic_variant.kind] [@@deriving show]

    module Constructor : sig
      type t = [%import: Odoc_model.Lang.TypeExpr.Polymorphic_variant.Constructor.t] [@@deriving show]
    end

    type element = [%import: Odoc_model.Lang.TypeExpr.Polymorphic_variant.element] [@@deriving show]

    type t = [%import: Odoc_model.Lang.TypeExpr.Polymorphic_variant.t] [@@deriving show]
  end

  module Object : sig
    type method_ = [%import: Odoc_model.Lang.TypeExpr.Object.method_] [@@deriving show]

    type field = [%import: Odoc_model.Lang.TypeExpr.Object.field] [@@deriving show]

    type t = [%import: Odoc_model.Lang.TypeExpr.Object.t] [@@deriving show]
  end

  module Package : sig
    type substitution = [%import: Odoc_model.Lang.TypeExpr.Package.substitution] [@@deriving show]

    type t = [%import: Odoc_model.Lang.TypeExpr.Package.t] [@@deriving show]
  end

  type label = [%import: Odoc_model.Lang.TypeExpr.label] [@@deriving show]

  type t = [%import: Odoc_model.Lang.TypeExpr.t] [@@deriving show]
end =
  TypeExpr

module%gen rec Compilation_unit : sig
  module Import : sig
    type t = [%import: Odoc_model.Lang.Compilation_unit.Import.t] [@@deriving show]
  end

  module Source : sig
    type t = [%import: Odoc_model.Lang.Compilation_unit.Source.t] [@@deriving show]
  end

  module Packed : sig
    type item = [%import: Odoc_model.Lang.Compilation_unit.Packed.item] [@@deriving show]

    type t = [%import: Odoc_model.Lang.Compilation_unit.Packed.t] [@@deriving show]
  end

  type content = [%import: Odoc_model.Lang.Compilation_unit.content] [@@deriving show]

  type t = [%import: Odoc_model.Lang.Compilation_unit.t] [@@deriving show]
end =
  Compilation_unit

module%gen rec Page : sig
  type t = [%import: Odoc_model.Lang.Page.t] [@@deriving show]
end =
  Page
