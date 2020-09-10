Build the library and put the object files into the directory "out":

```sh
$ dune build -p basic
$ dune install --prefix=out basic
Installing out/lib/basic/META
Installing out/lib/basic/basic.a
Installing out/lib/basic/basic.cma
Installing out/lib/basic/basic.cmi
Installing out/lib/basic/basic.cmt
Installing out/lib/basic/basic.cmti
Installing out/lib/basic/basic.cmx
Installing out/lib/basic/basic.cmxa
Installing out/lib/basic/basic.cmxs
Installing out/lib/basic/basic.ml
Installing out/lib/basic/basic.mli
Installing out/lib/basic/dune-package
Installing out/lib/basic/opam
```

Generate the Makefile:

```sh
$ odocmkgen -w basic out/lib > Makefile
```

Build:

```sh
$ make html
odocmkgen compile -w basic "out/lib"
Warning, couldn't find dep CamlinternalFormatBasics of file basic/basic.cmti
Warning, couldn't find dep Stdlib of file basic/basic.cmti
time odoc compile --package basic out/lib/basic/basic.cmti  -o odocs/basic/basic.odoc
0.00user 0.00system 0:00.00elapsed 66%CPU (0avgtext+0avgdata 12996maxresident)k
0inputs+8outputs (0major+1258minor)pagefaults 0swaps
time odoc link odocs/basic/basic.odoc -o odocls/basic/basic.odocl
Starting link
0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 12988maxresident)k
0inputs+8outputs (0major+1241minor)pagefaults 0swaps
odocmkgen generate --package basic
odoc html-generate odocls/basic/basic.odocl --output-dir html
```

```sh
$ find odocs
odocs
odocs/basic
odocs/basic/basic.odoc
$ find odocls
odocls
odocls/basic
odocls/basic/basic.odocl
$ find html
html
html/basic
html/basic/Basic
html/basic/Basic/index.html
```

```sh
$ odoc_print odocls/basic/basic.odocl
```
