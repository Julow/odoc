Build the documentation of a simple Dune library.

  $ dune build @install @doc
  File "dune_odoc_test.cmt":
  Couldn't find some external dependencies:
    Dune_odoc_test__Bar Dune_odoc_test__Foo
  File "dune_odoc_test__Foo.cmt":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "dune_odoc_test__Bar.cmt":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib

  $ find _build/default/_doc/_html -name '*.html' | sort
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test/Bar/index.html
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test/Foo/index.html
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test/index.html
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test__Bar/index.html
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test__Foo/index.html
  _build/default/_doc/_html/dune_odoc_test/index.html
  _build/default/_doc/_html/index.html
