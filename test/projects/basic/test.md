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
0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 13408maxresident)k
0inputs+8outputs (0major+1281minor)pagefaults 0swaps
time odoc link odocs/basic/basic.odoc -o odocls/basic/basic.odocl
Starting link
0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 13464maxresident)k
0inputs+8outputs (0major+1271minor)pagefaults 0swaps
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
{
  "name": [ [ "`Root", [ "<root>" ] ], "Basic" ],
  "content": [
    [
      [ "lib/basic.mli", [ "1", "4" ], [ "1", "20" ] ],
      [
        "`Paragraph",
        [
          [
            [ "lib/basic.mli", [ "1", "4" ], [ "1", "5" ] ],
            [ "`Word", "A" ]
          ],
          [ [ "lib/basic.mli", [ "1", "5" ], [ "1", "6" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "6" ], [ "1", "11" ] ],
            [ "`Word", "basic" ]
          ],
          [ [ "lib/basic.mli", [ "1", "11" ], [ "1", "12" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "12" ], [ "1", "20" ] ],
            [ "`Word", "library." ]
          ]
        ]
      ]
    ]
  ],
  "digest": "<digest>"
}{
  "id": [ [ "`Root", [ "<root>" ] ], "Basic" ],
  "doc": [
    [
      [ "lib/basic.mli", [ "1", "4" ], [ "1", "20" ] ],
      [
        "`Paragraph",
        [
          [
            [ "lib/basic.mli", [ "1", "4" ], [ "1", "5" ] ],
            [ "`Word", "A" ]
          ],
          [ [ "lib/basic.mli", [ "1", "5" ], [ "1", "6" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "6" ], [ "1", "11" ] ],
            [ "`Word", "basic" ]
          ],
          [ [ "lib/basic.mli", [ "1", "11" ], [ "1", "12" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "12" ], [ "1", "20" ] ],
            [ "`Word", "library." ]
          ]
        ]
      ]
    ]
  ],
  "digest": "<digest>",
  "imports": [
    [ "Unresolved", [ "CamlinternalFormatBasics", [ "<digest>" ] ] ],
    [ "Unresolved", [ "Stdlib", [ "<digest>" ] ] ]
  ],
  "source": [
    {
      "file": "lib/basic.mli",
      "build_dir":
        "/home/jules/w/odoc/_build/default/test/projects/basic/_build/default",
      "digest": "<digest>"
    }
  ],
  "interface": "true",
  "hidden": "false",
  "content": [
    "Module",
    [
      [
        "Type",
        [
          [ "Ordinary" ],
          {
            "id": [
              [ "`Parent", [ [ "`Root", [ "<root>" ] ], "Basic" ] ],
              "t"
            ],
            "doc": [
              [
                [ "lib/basic.mli", [ "3", "4" ], [ "3", "7" ] ],
                [
                  "`Paragraph",
                  [
                    [
                      [ "lib/basic.mli", [ "3", "4" ], [ "3", "7" ] ],
                      [ "`Code_span", "t" ]
                    ]
                  ]
                ]
              ]
            ],
            "equation": {
              "params": [
                {
                  "desc": [ "Var", "a" ],
                  "variance": [],
                  "injectivity": "false"
                }
              ],
              "private_": "false",
              "manifest": [],
              "constraints": []
            },
            "representation": []
          }
        ]
      ],
      [
        "Value",
        {
          "id": [
            [ "`Parent", [ [ "`Root", [ "<root>" ] ], "Basic" ] ],
            "get"
          ],
          "doc": [
            [
              [ "lib/basic.mli", [ "6", "4" ], [ "6", "9" ] ],
              [
                "`Paragraph",
                [
                  [
                    [ "lib/basic.mli", [ "6", "4" ], [ "6", "9" ] ],
                    [ "`Code_span", "get" ]
                  ]
                ]
              ]
            ]
          ],
          "type_": [
            "Arrow",
            [
              [],
              [
                "Constr",
                [
                  [
                    "`Resolved",
                    [ "`Identifier", [ [ "`Root", [] ], "string" ] ]
                  ],
                  []
                ]
              ],
              [
                "Arrow",
                [
                  [],
                  [
                    "Constr",
                    [
                      [
                        "`Resolved",
                        [
                          "`Identifier",
                          [
                            [
                              "`Parent",
                              [ [ "`Root", [ "<root>" ] ], "Basic" ]
                            ],
                            "t"
                          ]
                        ]
                      ],
                      [ [ "Var", "a" ] ]
                    ]
                  ],
                  [
                    "Constr",
                    [
                      [
                        "`Resolved",
                        [ "`Identifier", [ [ "`Root", [] ], "option" ] ]
                      ],
                      [ [ "Var", "a" ] ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        }
      ],
      [
        "Value",
        {
          "id": [
            [ "`Parent", [ [ "`Root", [ "<root>" ] ], "Basic" ] ],
            "set"
          ],
          "doc": [
            [
              [ "lib/basic.mli", [ "9", "4" ], [ "9", "9" ] ],
              [
                "`Paragraph",
                [
                  [
                    [ "lib/basic.mli", [ "9", "4" ], [ "9", "9" ] ],
                    [ "`Code_span", "set" ]
                  ]
                ]
              ]
            ]
          ],
          "type_": [
            "Arrow",
            [
              [],
              [
                "Constr",
                [
                  [
                    "`Resolved",
                    [ "`Identifier", [ [ "`Root", [] ], "string" ] ]
                  ],
                  []
                ]
              ],
              [
                "Arrow",
                [
                  [],
                  [ "Var", "a" ],
                  [
                    "Arrow",
                    [
                      [],
                      [
                        "Constr",
                        [
                          [
                            "`Resolved",
                            [
                              "`Identifier",
                              [
                                [
                                  "`Parent",
                                  [ [ "`Root", [ "<root>" ] ], "Basic" ]
                                ],
                                "t"
                              ]
                            ]
                          ],
                          [ [ "Var", "a" ] ]
                        ]
                      ],
                      [
                        "Constr",
                        [
                          [
                            "`Resolved",
                            [
                              "`Identifier",
                              [
                                [
                                  "`Parent",
                                  [ [ "`Root", [ "<root>" ] ], "Basic" ]
                                ],
                                "t"
                              ]
                            ]
                          ],
                          [ [ "Var", "a" ] ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        }
      ]
    ]
  ],
  "expansion": []
}
$ odoc_print odocs/basic/basic.odoc
{
  "name": [ [ "`Root", [ "<root>" ] ], "Basic" ],
  "content": [
    [
      [ "lib/basic.mli", [ "1", "4" ], [ "1", "20" ] ],
      [
        "`Paragraph",
        [
          [
            [ "lib/basic.mli", [ "1", "4" ], [ "1", "5" ] ],
            [ "`Word", "A" ]
          ],
          [ [ "lib/basic.mli", [ "1", "5" ], [ "1", "6" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "6" ], [ "1", "11" ] ],
            [ "`Word", "basic" ]
          ],
          [ [ "lib/basic.mli", [ "1", "11" ], [ "1", "12" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "12" ], [ "1", "20" ] ],
            [ "`Word", "library." ]
          ]
        ]
      ]
    ]
  ],
  "digest": "<digest>"
}{
  "id": [ [ "`Root", [ "<root>" ] ], "Basic" ],
  "doc": [
    [
      [ "lib/basic.mli", [ "1", "4" ], [ "1", "20" ] ],
      [
        "`Paragraph",
        [
          [
            [ "lib/basic.mli", [ "1", "4" ], [ "1", "5" ] ],
            [ "`Word", "A" ]
          ],
          [ [ "lib/basic.mli", [ "1", "5" ], [ "1", "6" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "6" ], [ "1", "11" ] ],
            [ "`Word", "basic" ]
          ],
          [ [ "lib/basic.mli", [ "1", "11" ], [ "1", "12" ] ], [ "`Space" ] ],
          [
            [ "lib/basic.mli", [ "1", "12" ], [ "1", "20" ] ],
            [ "`Word", "library." ]
          ]
        ]
      ]
    ]
  ],
  "digest": "<digest>",
  "imports": [
    [ "Unresolved", [ "CamlinternalFormatBasics", [ "<digest>" ] ] ],
    [ "Unresolved", [ "Stdlib", [ "<digest>" ] ] ]
  ],
  "source": [
    {
      "file": "lib/basic.mli",
      "build_dir":
        "/home/jules/w/odoc/_build/default/test/projects/basic/_build/default",
      "digest": "<digest>"
    }
  ],
  "interface": "true",
  "hidden": "false",
  "content": [
    "Module",
    [
      [
        "Type",
        [
          [ "Ordinary" ],
          {
            "id": [
              [ "`Parent", [ [ "`Root", [ "<root>" ] ], "Basic" ] ],
              "t"
            ],
            "doc": [
              [
                [ "lib/basic.mli", [ "3", "4" ], [ "3", "7" ] ],
                [
                  "`Paragraph",
                  [
                    [
                      [ "lib/basic.mli", [ "3", "4" ], [ "3", "7" ] ],
                      [ "`Code_span", "t" ]
                    ]
                  ]
                ]
              ]
            ],
            "equation": {
              "params": [
                {
                  "desc": [ "Var", "a" ],
                  "variance": [],
                  "injectivity": "false"
                }
              ],
              "private_": "false",
              "manifest": [],
              "constraints": []
            },
            "representation": []
          }
        ]
      ],
      [
        "Value",
        {
          "id": [
            [ "`Parent", [ [ "`Root", [ "<root>" ] ], "Basic" ] ],
            "get"
          ],
          "doc": [
            [
              [ "lib/basic.mli", [ "6", "4" ], [ "6", "9" ] ],
              [
                "`Paragraph",
                [
                  [
                    [ "lib/basic.mli", [ "6", "4" ], [ "6", "9" ] ],
                    [ "`Code_span", "get" ]
                  ]
                ]
              ]
            ]
          ],
          "type_": [
            "Arrow",
            [
              [],
              [
                "Constr",
                [
                  [
                    "`Resolved",
                    [ "`Identifier", [ [ "`Root", [] ], "string" ] ]
                  ],
                  []
                ]
              ],
              [
                "Arrow",
                [
                  [],
                  [
                    "Constr",
                    [
                      [
                        "`Resolved",
                        [
                          "`Identifier",
                          [
                            [
                              "`Parent",
                              [ [ "`Root", [ "<root>" ] ], "Basic" ]
                            ],
                            "t"
                          ]
                        ]
                      ],
                      [ [ "Var", "a" ] ]
                    ]
                  ],
                  [
                    "Constr",
                    [
                      [
                        "`Resolved",
                        [ "`Identifier", [ [ "`Root", [] ], "option" ] ]
                      ],
                      [ [ "Var", "a" ] ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        }
      ],
      [
        "Value",
        {
          "id": [
            [ "`Parent", [ [ "`Root", [ "<root>" ] ], "Basic" ] ],
            "set"
          ],
          "doc": [
            [
              [ "lib/basic.mli", [ "9", "4" ], [ "9", "9" ] ],
              [
                "`Paragraph",
                [
                  [
                    [ "lib/basic.mli", [ "9", "4" ], [ "9", "9" ] ],
                    [ "`Code_span", "set" ]
                  ]
                ]
              ]
            ]
          ],
          "type_": [
            "Arrow",
            [
              [],
              [
                "Constr",
                [
                  [
                    "`Resolved",
                    [ "`Identifier", [ [ "`Root", [] ], "string" ] ]
                  ],
                  []
                ]
              ],
              [
                "Arrow",
                [
                  [],
                  [ "Var", "a" ],
                  [
                    "Arrow",
                    [
                      [],
                      [
                        "Constr",
                        [
                          [
                            "`Resolved",
                            [
                              "`Identifier",
                              [
                                [
                                  "`Parent",
                                  [ [ "`Root", [ "<root>" ] ], "Basic" ]
                                ],
                                "t"
                              ]
                            ]
                          ],
                          [ [ "Var", "a" ] ]
                        ]
                      ],
                      [
                        "Constr",
                        [
                          [
                            "`Resolved",
                            [
                              "`Identifier",
                              [
                                [
                                  "`Parent",
                                  [ [ "`Root", [ "<root>" ] ], "Basic" ]
                                ],
                                "t"
                              ]
                            ]
                          ],
                          [ [ "Var", "a" ] ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        }
      ]
    ]
  ],
  "expansion": []
}
```
