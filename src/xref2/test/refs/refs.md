Testing resolution of references

## Env

Prelude:

```ocaml
(* Prelude *)
#require "odoc.xref2";;
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

  type t1 = C1
  val f1 : unit -> unit
  module type T1 = sig end
  exception E1
  external e1 : unit -> unit = "e1"
  class c1 : object end
  class type ct1 = object end

  module M : sig
    type t2 = C2
    val f2 : unit -> unit
    module type T2 = sig end
    exception E2
    external e2 : unit -> unit = "e2"
    class c2 : object end
    class type ct2 = object end
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
Exception: Failure "resolve_reference".
# resolve_ref "type:t1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Type (`Root (Common.root, Root), t1))
# resolve_ref "type:M.t2"
Exception: Failure "resolve_reference".
# resolve_ref "module-type:T1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`ModuleType (`Root (Common.root, Root), T1))
# resolve_ref "module-type:M.T1"
Exception: Failure "resolve_reference".
# resolve_ref "exception:E1"
Exception: Failure "resolve_reference".
# resolve_ref "exception:M.E2"
Exception: Failure "resolve_reference".
# resolve_ref "constructor:C1"
Exception: Failure "resolve_reference".
# resolve_ref "constructor:M.C2"
Exception: Failure "resolve_reference".
# resolve_ref "val:e1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Value (`Root (Common.root, Root), e1))
# resolve_ref "val:M.e2"
Exception: Failure "resolve_reference".
# resolve_ref "class:c1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Class (`Root (Common.root, Root), <abstr>))
# resolve_ref "class:M.c2"
Exception: Failure "resolve_reference".
# resolve_ref "classtype:ct1"
Exception: Odoc_model.Error.Conveyed_by_exception _.
File "_none_", line 1, characters 0-9:
'classtype' is deprecated, use 'class-type' instead.
# resolve_ref "classtype:M.ct2"
Exception: Odoc_model.Error.Conveyed_by_exception _.
File "_none_", line 1, characters 0-9:
'classtype' is deprecated, use 'class-type' instead.
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
# resolve_ref "t1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Type (`Root (Common.root, Root), t1))
# resolve_ref "M.t2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Type (`Identifier (`Module (`Root (Common.root, Root), M)), t2)
# resolve_ref "T1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`ModuleType (`Root (Common.root, Root), T1))
# resolve_ref "M.T2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`ModuleType (`Identifier (`Module (`Root (Common.root, Root), M)), T2)
# resolve_ref "E1"
Exception: Failure "resolve_reference".
# resolve_ref "M.E2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Exception (`Identifier (`Module (`Root (Common.root, Root), M)), E2)
# resolve_ref "C1"
Exception: Failure "resolve_reference".
# resolve_ref "M.C2"
Exception: Failure "resolve_reference".
# resolve_ref "e1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Value (`Root (Common.root, Root), e1))
# resolve_ref "M.e2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Value (`Identifier (`Module (`Root (Common.root, Root), M)), e2)
# resolve_ref "c1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`Class (`Root (Common.root, Root), <abstr>))
# resolve_ref "M.c2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Class (`Identifier (`Module (`Root (Common.root, Root), M)), <abstr>)
# resolve_ref "ct1"
- : Odoc_model.Paths_types.Resolved_reference.any =
`Identifier (`ClassType (`Root (Common.root, Root), <abstr>))
# resolve_ref "M.ct2"
- : Odoc_model.Paths_types.Resolved_reference.any =
`ClassType (`Identifier (`Module (`Root (Common.root, Root), M)), <abstr>)
```
