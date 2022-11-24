Make sure wrapped libraries don't interfere with generating the source code.
Test both canonical paths and hidden units.
It's a simpler case than Dune's wrapping.

  $ ocamlc -c -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -o main__B.cmo b.ml -bin-annot -I .
  $ ocamlc -c main.ml -bin-annot -I .

  $ odoc compile --impl a.ml -I . main__A.cmt
  $ odoc compile --impl b.ml -I . main__B.cmt
  $ odoc compile --impl main.ml -I . main.cmt

  $ odoc link -I . main.odoc

  $ odoc html-generate --indent -o html main.odocl

Look if all the source files are generated:

  $ find html | sort
  html
  html/Main
  html/Main/A
  html/Main/A/A.ml.html
  html/Main/A/index.html
  html/Main/B
  html/Main/B/B.ml.html
  html/Main/B/index.html
  html/Main/Main.ml.html
  html/Main/index.html

  $ odoc_print main.odocl
  {
    "id": { "`Root": [ "None", "Main" ] },
    "root": "<root>",
    "digest": "<digest>",
    "imports": [
      { "Unresolved": [ "CamlinternalFormatBasics", { "Some": "<digest>" } ] },
      { "Resolved": [ "<root>", "Main__A" ] },
      { "Resolved": [ "<root>", "Main__B" ] },
      { "Unresolved": [ "Stdlib", { "Some": "<digest>" } ] }
    ],
    "source": {
      "Some": {
        "file": "main.ml",
        "build_dir": "$TESTCASE_ROOT",
        "digest": "<digest>"
      }
    },
    "interface": "true",
    "hidden": "false",
    "content": {
      "Module": {
        "items": [
          {
            "Module": [
              "Ordinary",
              {
                "id": { "`Module": [ { "`Root": [ "None", "Main" ] }, "A" ] },
                "locs": {
                  "impl": "None",
                  "intf": {
                    "Some": "File \"main.ml\", line 1, characters 0-18"
                  }
                },
                "doc": [],
                "type_": {
                  "Alias": [
                    {
                      "`Resolved": {
                        "`Hidden": {
                          "`Identifier": { "`Root": [ "None", "Main__A" ] }
                        }
                      }
                    },
                    {
                      "Some": {
                        "Signature": {
                          "items": [
                            {
                              "Type": [
                                "Ordinary",
                                {
                                  "id": {
                                    "`Type": [
                                      {
                                        "`Module": [
                                          { "`Root": [ "None", "Main" ] },
                                          "A"
                                        ]
                                      },
                                      "t"
                                    ]
                                  },
                                  "locs": {
                                    "impl": {
                                      "Some":
                                        "File \"a.ml\", line 1, characters 0-6"
                                    },
                                    "intf": {
                                      "Some":
                                        "File \"a.ml\", line 1, characters 0-6"
                                    }
                                  },
                                  "doc": [],
                                  "equation": {
                                    "params": [],
                                    "private_": "false",
                                    "manifest": "None",
                                    "constraints": []
                                  },
                                  "representation": "None"
                                }
                              ]
                            },
                            {
                              "Value": {
                                "id": {
                                  "`Value": [
                                    {
                                      "`Module": [
                                        { "`Root": [ "None", "Main" ] },
                                        "A"
                                      ]
                                    },
                                    "x"
                                  ]
                                },
                                "locs": {
                                  "impl": {
                                    "Some":
                                      "File \"a.ml\", line 3, characters 4-5"
                                  },
                                  "intf": {
                                    "Some":
                                      "File \"a.ml\", line 3, characters 4-5"
                                  }
                                },
                                "doc": [],
                                "type_": {
                                  "Constr": [
                                    {
                                      "`Resolved": {
                                        "`Identifier": { "`CoreType": "int" }
                                      }
                                    },
                                    []
                                  ]
                                },
                                "value": "Abstract"
                              }
                            }
                          ],
                          "compiled": "true",
                          "doc": []
                        }
                      }
                    }
                  ]
                },
                "canonical": {
                  "Some": { "`Dot": [ { "`Root": "Main" }, "A" ] }
                },
                "hidden": "false"
              }
            ]
          },
          {
            "Module": [
              "Ordinary",
              {
                "id": { "`Module": [ { "`Root": [ "None", "Main" ] }, "B" ] },
                "locs": {
                  "impl": "None",
                  "intf": {
                    "Some": "File \"main.ml\", line 4, characters 0-18"
                  }
                },
                "doc": [],
                "type_": {
                  "Alias": [
                    {
                      "`Resolved": {
                        "`Hidden": {
                          "`Identifier": { "`Root": [ "None", "Main__B" ] }
                        }
                      }
                    },
                    {
                      "Some": {
                        "Signature": {
                          "items": [
                            {
                              "Value": {
                                "id": {
                                  "`Value": [
                                    {
                                      "`Module": [
                                        { "`Root": [ "None", "Main" ] },
                                        "B"
                                      ]
                                    },
                                    "x"
                                  ]
                                },
                                "locs": {
                                  "impl": {
                                    "Some":
                                      "File \"b.ml\", line 1, characters 4-5"
                                  },
                                  "intf": {
                                    "Some":
                                      "File \"b.ml\", line 1, characters 4-5"
                                  }
                                },
                                "doc": [],
                                "type_": {
                                  "Constr": [
                                    {
                                      "`Resolved": {
                                        "`Identifier": { "`CoreType": "int" }
                                      }
                                    },
                                    []
                                  ]
                                },
                                "value": "Abstract"
                              }
                            }
                          ],
                          "compiled": "true",
                          "doc": []
                        }
                      }
                    }
                  ]
                },
                "canonical": {
                  "Some": { "`Dot": [ { "`Root": "Main" }, "B" ] }
                },
                "hidden": "false"
              }
            ]
          }
        ],
        "compiled": "true",
        "doc": []
      }
    },
    "expansion": "None",
    "canonical": "None",
    "sources": [
      {
        "parent": { "`Root": [ "None", "Main" ] },
        "intf_source": "<source code>",
        "impl_source": "<source code>"
      },
      {
        "parent": { "`Module": [ { "`Root": [ "None", "Main" ] }, "B" ] },
        "intf_source": "<source code>",
        "impl_source": "<source code>"
      },
      {
        "parent": { "`Module": [ { "`Root": [ "None", "Main" ] }, "A" ] },
        "intf_source": "<source code>",
        "impl_source": "<source code>"
      }
    ]
  }

  $ cat html/Main/A/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>A (Main.A)</title>
    <link rel="stylesheet" href="../../odoc.css"/><meta charset="utf-8"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../index.html">Main</a> &#x00BB; A
    </nav>
    <header class="odoc-preamble">
     <h1>Module <code><span>Main.A</span></code></h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec type anchored" id="type-t">
       <a href="#type-t" class="anchor"></a>
       <a href="../Main.ml.html#L1" class="source_link"></a>
       <code><span><span class="keyword">type</span> t</span></code>
      </div>
     </div>
     <div class="odoc-spec">
      <div class="spec value anchored" id="val-x">
       <a href="#val-x" class="anchor"></a>
       <a href="../Main.ml.html#L3" class="source_link"></a>
       <code><span><span class="keyword">val</span> x : int</span></code>
      </div>
     </div>
    </div>
   </body>
  </html>
