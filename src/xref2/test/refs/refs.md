Testing resolution of references

## Env

Prelude:

```ocaml
(* Prelude *)
#require "odoc.xref_test";;
open Odoc_xref2;;
open Odoc_xref_test;;

#install_printer Common.root_pp;;
#install_printer Odoc_model.Names.UnitName.fmt;;
#install_printer Odoc_model.Names.ValueName.fmt;;
#install_printer Odoc_model.Names.ModuleName.fmt;;
#install_printer Odoc_model.Names.ModuleTypeName.fmt;;
#install_printer Odoc_model.Names.TypeName.fmt;;
#install_printer Odoc_model.Names.ParameterName.fmt;;
#install_printer Odoc_model.Names.ExceptionName.fmt;;
#install_printer Odoc_model.Names.FieldName.fmt;;
```

Test data:

```ocaml
let test_mli = {|

  val f1 : unit -> unit

  module M : sig

    val f2 : unit -> unit

  end

|}
let sg = Common.signature_of_mli_string test_mli
let env = Env.open_signature sg Env.empty
```

Helpers:

```ocaml
let parse_ref ref_str =
  let open Odoc_model in
  Error.set_warn_error true;
  let parse acc = Odoc_parser__Reference.parse acc (Location_.span []) ref_str in
  match Error.shed_warnings (Error.accumulate_warnings parse) with
  | Ok ref -> ref
  | Error e -> failwith (Error.to_string e)

let resolve_ref ref_str =
  match Ref_tools.resolve_reference env (parse_ref ref_str) with
  | None -> failwith "resolve_reference"
  | Some r -> r
```

## Resolving

Explicit kind

```ocaml
# resolve_ref "module:M"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Module (`Root (Common.root, Root), M))
# resolve_ref "val:f1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Value (`Root (Common.root, Root), f1))
# resolve_ref "val:M.f2"
Exception: Failure "erk".
```

Implicit

```ocaml
# resolve_ref "M"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Module (`Root (Common.root, Root), M))
# resolve_ref "f1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Value (`Root (Common.root, Root), f1))
# resolve_ref "M.f2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Value (`Identifier (`Module (`Root (Common.root, Root), M)), f2)
```
