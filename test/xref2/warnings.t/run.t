Test the behavior of warnings generated while compiling and linking.

  $ ocamlc -c -bin-annot b.mli
  $ ocamlc -c -bin-annot a.mli

A contains both parsing errors and a reference to B that isn't compiled yet:

  $ odoc compile --warn-error --package test a.cmti
  File "a.mli", line 8, characters 23-23:
  End of text is not allowed in '{!...}' (cross-reference).
  File "a.mli", line 8, characters 22-23:
  Identifier in reference should not be empty.
  File "a.cmti":
  Couldn't find some external dependencies:
    B CamlinternalFormatBasics Stdlib
  ERROR: Warnings have been generated.
  [1]

  $ odoc compile --package test b.cmti
  File "b.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  $ odoc compile --package test a.cmti
  File "a.mli", line 8, characters 23-23:
  End of text is not allowed in '{!...}' (cross-reference).
  File "a.mli", line 8, characters 22-23:
  Identifier in reference should not be empty.
  File "a.cmti":
  Couldn't find some external dependencies:
    B CamlinternalFormatBasics Stdlib

  $ odoc errors a.odoc
  File "a.mli", line 8, characters 23-23:
  End of text is not allowed in '{!...}' (cross-reference).
  File "a.mli", line 8, characters 22-23:
  Identifier in reference should not be empty.
  File "a.cmti":
  Couldn't find some external dependencies:
    B CamlinternalFormatBasics Stdlib

A contains linking errors:

  $ odoc link -I . a.odoc

  $ odoc errors a.odocl
  File "a.mli", line 8, characters 23-23:
  End of text is not allowed in '{!...}' (cross-reference).
  File "a.mli", line 8, characters 22-23:
  Identifier in reference should not be empty.
  File "a.cmti":
  Couldn't find some external dependencies:
    B CamlinternalFormatBasics Stdlib

It is possible to hide the warnings too:

  $ odoc compile --print-warnings false --package test a.cmti
  $ odoc link --print-warnings false a.odoc
  $ ODOC_PRINT_WARNINGS=false odoc compile --package test a.cmti
