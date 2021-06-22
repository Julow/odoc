Testing the depends command.

  $ ocamlc -c -no-alias-deps -bin-annot -w -49 -o lib.cmti lib.mli
  $ ocamlc -c -bin-annot -I . -o lib_a.cmti a.mli
  $ ocamlc -c -bin-annot -I . -o lib_b.cmti b.mli

  $ odoc compile-deps lib_b.cmti | grep -v "CamlinternalFormatBasics\|Stdlib\|Pervasives" | cut -d ' ' -f 1 | sort -u
  Lib
  Lib_a
  Lib_b

  $ odoc compile --pkg lib -I . lib.cmti
  File "lib.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Lib_a Lib_b Stdlib
  $ odoc compile --pkg lib -I . lib_a.cmti
  File "lib_a.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  $ odoc compile --pkg lib -I . lib_b.cmti
  File "lib_b.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib

  $ odoc link-deps . | cut -d ' ' -f 1-2 | sort
  lib Lib
  lib Lib_a
