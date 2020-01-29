```ocaml env=e1
(* Prelude *)
#require "odoc.xref_test";;
open Odoc_xref2;;
open Odoc_xref_test;;
#install_printer Common.root_pp;;
#print_length 6000;;
#print_depth 3;;
```

```ocaml env=e1
let f = Odoc_odoc.Fs.File.of_string "/Users/jon/devel/base.v0.13.0/_build/default/src/.base.objs/byte/base.odocl";;
let base = Odoc_odoc.Compilation_unit.load f;;
let contents = base.Odoc_model.Lang.Compilation_unit.content;;
let Odoc_model.Lang.Compilation_unit.Module m = contents;;
let array_lens = Common.LangUtils.Lens.Signature.module_ "Array";;
let array = Common.LangUtils.Lens.get array_lens m;;
let Some expn = array.Odoc_model.Lang.Module.expansion;;
let Odoc_model.Lang.Module.Signature sg = expn;;
```

```ocaml env=e1
let f = Odoc_odoc.Fs.File.of_string "/Users/jon/devel/base.v0.13.0/_build/default/src/.base.objs/byte/base__array.odoc";;
let array = Odoc_odoc.Compilation_unit.load f;;
let contents = array.Odoc_model.Lang.Compilation_unit.content;;
let Odoc_model.Lang.Compilation_unit.Module m = contents;;
#print_depth 15;;
```

```ocaml env=e1
# let _::_::_::_ = sg;;
Line 1, characters 5-15:
Warning 8: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
(_::_::[]|_::[]|[])
```

```ocaml env=e1
# m;;
- : Odoc_model.Lang.Signature.t =
[Odoc_model.Lang.Signature.Type (Odoc_model.Lang.Signature.Ordinary,
  {Odoc_model.Lang.TypeDecl.id =
    `Type (`Root (Common.root, "Base__Array"), "t");
   doc = [];
   equation =
    {Odoc_model.Lang.TypeDecl.Equation.params =
      [(Odoc_model.Lang.TypeDecl.Var "a", None)];
     private_ = false;
     manifest =
      Some
       (Odoc_model.Lang.TypeExpr.Constr
         (`Resolved (`Identifier (`CoreType "array")),
         [Odoc_model.Lang.TypeExpr.Var "a"]));
     constraints = []};
   representation = None});
 Odoc_model.Lang.Signature.Include
  {Odoc_model.Lang.Include.parent = `Root (Common.root, "Base__Array");
   doc =
    [{Odoc_model.Location_.location =
       {Odoc_model.Location_.file = "src/array.mli";
        start = {Odoc_model.Location_.line = 11; column = 21};
        end_ = {Odoc_model.Location_.line = 11; column = 28}};
      value = `Tag `Inline}];
   decl =
    Odoc_model.Lang.Module.ModuleType
     (Odoc_model.Lang.ModuleType.Signature
       [Odoc_model.Lang.Signature.Value
         {Odoc_model.Lang.Value.id =
           `Value (`Root (Common.root, "Base__Array"), "compare");
          doc = [];
          type_ =
           Odoc_model.Lang.TypeExpr.Arrow (None,
            Odoc_model.Lang.TypeExpr.Arrow (None,
             Odoc_model.Lang.TypeExpr.Var "a",
             Odoc_model.Lang.TypeExpr.Arrow (None,
              Odoc_model.Lang.TypeExpr.Var "a",
              Odoc_model.Lang.TypeExpr.Constr
               (`Resolved (`Identifier (`CoreType "int")), []))),
            Odoc_model.Lang.TypeExpr.Arrow (None,
             Odoc_model.Lang.TypeExpr.Constr
              (`Resolved (`Identifier (`Type (`Root ...))),
                 [Odoc_model.Lang.TypeExpr.Var "a"]),
              Odoc_model.Lang.TypeExpr.Arrow (None,
               Odoc_model.Lang.TypeExpr.Constr
                (`Resolved (`Identifier (`Type (...))),
                [Odoc_model.Lang.TypeExpr.Var "a"]),
               Odoc_model.Lang.TypeExpr.Constr
                (`Resolved (`Identifier (`CoreType "int")), []))))};
         Odoc_model.Lang.Signature.Include
          {Odoc_model.Lang.Include.parent =
            `Root (Common.root, "Base__Array");
           doc = [];
           decl =
            Odoc_model.Lang.Module.ModuleType
             (Odoc_model.Lang.ModuleType.With
               (Odoc_model.Lang.ModuleType.Path
                 (`Resolved (`ModuleType (`Alias (...), "S1"))),
               [Odoc_model.Lang.ModuleType.TypeSubst
                 (`Resolved (`Type (`Root, "t")),
                 {Odoc_model.Lang.TypeDecl.Equation.params =
                   [(Odoc_model.Lang.TypeDecl.Var ...)]; private_ = false;
                   manifest =
                    Some (Odoc_model.Lang.TypeExpr.Constr (`Resolved ...));
                    constraints = []})]));
             expansion =
              {Odoc_model.Lang.Include.resolved = true;
               content =
                [Odoc_model.Lang.Signature.Value
                  {Odoc_model.Lang.Value.id =
                    `Value (`Root (...), "t_of_sexp");
                   doc = [];
                   type_ =
                    Odoc_model.Lang.TypeExpr.Arrow (None,
                     Odoc_model.Lang.TypeExpr.Arrow (None,
                      Odoc_model.Lang.TypeExpr.Constr (`Resolved ...),
                       Odoc_model.Lang.TypeExpr.Var "a"),
                      Odoc_model.Lang.TypeExpr.Arrow (None,
                       Odoc_model.Lang.TypeExpr.Constr (`Resolved ...),
                        Odoc_model.Lang.TypeExpr.Constr (`Resolved ...)))};
                    Odoc_model.Lang.Signature.Value
                     {Odoc_model.Lang.Value.id =
                       `Value (`Root (...), "sexp_of_t");
                      doc = [];
                      type_ =
                       Odoc_model.Lang.TypeExpr.Arrow (None,
                        Odoc_model.Lang.TypeExpr.Arrow (None,
                         Odoc_model.Lang.TypeExpr.Var "a",
                         Odoc_model.Lang.TypeExpr.Constr (`Resolved ...)),
                         Odoc_model.Lang.TypeExpr.Arrow (None,
                          Odoc_model.Lang.TypeExpr.Constr (`Resolved ...),
                           Odoc_model.Lang.TypeExpr.Constr (`Resolved ...)))}]}}]);
            expansion =
             {Odoc_model.Lang.Include.resolved = true;
              content =
               [Odoc_model.Lang.Signature.Value
                 {Odoc_model.Lang.Value.id =
                   `Value (`Root (Common.root, "Base__Array"), "compare");
                  doc = [];
                  type_ =
                   Odoc_model.Lang.TypeExpr.Arrow (None,
                    Odoc_model.Lang.TypeExpr.Arrow (None,
                     Odoc_model.Lang.TypeExpr.Var "a",
                     Odoc_model.Lang.TypeExpr.Arrow (None,
                      Odoc_model.Lang.TypeExpr.Var "a",
                      Odoc_model.Lang.TypeExpr.Constr
                       (`Resolved (`Identifier (`CoreType "int")), []))),
                    Odoc_model.Lang.TypeExpr.Arrow (None,
                     Odoc_model.Lang.TypeExpr.Constr
                      (`Resolved (`Identifier (`Type (`Root (...), "t"))),
                      [Odoc_model.Lang.TypeExpr.Var "a"]),
                     Odoc_model.Lang.TypeExpr.Arrow (None,
                      Odoc_model.Lang.TypeExpr.Constr
                       (`Resolved (`Identifier (`Type (`Root ...))),
                          [Odoc_model.Lang.TypeExpr.Var "a"]),
                       Odoc_model.Lang.TypeExpr.Constr
                        (`Resolved (`Identifier (`CoreType "int")), []))))};
                 Odoc_model.Lang.Signature.Value
                  {Odoc_model.Lang.Value.id =
                    `Value (`Root (Common.root, "Base__Array"), "t_of_sexp");
                   doc = [];
                   type_ =
                    Odoc_model.Lang.TypeExpr.Arrow (None,
                     Odoc_model.Lang.TypeExpr.Arrow (None,
                      Odoc_model.Lang.TypeExpr.Constr
                       (`Resolved (`Type (`Canonical (`Module ...), "t")),
                          []),
                       Odoc_model.Lang.TypeExpr.Var "a"),
                      Odoc_model.Lang.TypeExpr.Arrow (None,
                       Odoc_model.Lang.TypeExpr.Constr
                        (`Resolved (`Type (`Canonical (`Module ...), "t")),
                           []),
                        Odoc_model.Lang.TypeExpr.Constr
                         (`Resolved (`Identifier (`Type (`Root (...), "t"))),
                         [Odoc_model.Lang.TypeExpr.Var "a"])))};
                   Odoc_model.Lang.Signature.Value
                    {Odoc_model.Lang.Value.id =
                      `Value
                        (`Root (Common.root, "Base__Array"), "sexp_of_t");
                     doc = [];
                     type_ =
                      Odoc_model.Lang.TypeExpr.Arrow (None,
                       Odoc_model.Lang.TypeExpr.Arrow (None,
                        Odoc_model.Lang.TypeExpr.Var "a",
                        Odoc_model.Lang.TypeExpr.Constr
                         (`Resolved (`Type (`Canonical (`Module ...), "t")),
                            [])),
                        Odoc_model.Lang.TypeExpr.Arrow (None,
                         Odoc_model.Lang.TypeExpr.Constr
                          (`Resolved (`Identifier (`Type (`Root (...), "t"))),
                          [Odoc_model.Lang.TypeExpr.Var "a"]),
                         Odoc_model.Lang.TypeExpr.Constr
                          (`Resolved (`Type (`Canonical (`Module ...), "t")),
                             [])))}]}};
               Odoc_model.Lang.Signature.Include
                {Odoc_model.Lang.Include.parent =
                  `Root (Common.root, "Base__Array");
                 doc = [];
                 decl =
                  Odoc_model.Lang.Module.ModuleType
                   (Odoc_model.Lang.ModuleType.With
                     (Odoc_model.Lang.ModuleType.Path
                       (`Resolved
                          (`ModuleType
                             (`Canonical
                                (`Module
                                   (`Hidden (`Identifier (`Root ...)),
                                      "Binary_searchable"),
                                   `Dot (`Root "Base", "Binary_searchable")),
                                "S1"))),
                       [Odoc_model.Lang.ModuleType.TypeSubst
                         (`Resolved (`Type (`Root, "t")),
                         {Odoc_model.Lang.TypeDecl.Equation.params =
                           [(Odoc_model.Lang.TypeDecl.Var "a", None)];
                          private_ = false;
                          manifest =
                           Some
                            (Odoc_model.Lang.TypeExpr.Constr
                              (`Resolved
                                 (`Identifier (`Type (`Root (...), "t"))),
                              [Odoc_model.Lang.TypeExpr.Var "a"]));
                          constraints = []})]));
                  expansion =
                   {Odoc_model.Lang.Include.resolved = true;
                    content =
                     [Odoc_model.Lang.Signature.Value
                       {Odoc_model.Lang.Value.id =
                         `Value
                           (`Root (Common.root, "Base__Array"),
                            "binary_search");
                        doc = [];
                        type_ =
                         Odoc_model.Lang.TypeExpr.Constr
                          (`Resolved
                             (`Type
                                (`Canonical
                                   (`Module (`Hidden ...), `Dot (`Root ...)),
                                    "binary_search")),
                              [Odoc_model.Lang.TypeExpr.Constr
                                (`Resolved
                                   (`Identifier (`Type (`Root (...), "t"))),
                                [Odoc_model.Lang.TypeExpr.Var "a"]);
                               Odoc_model.Lang.TypeExpr.Var "a";
                               Odoc_model.Lang.TypeExpr.Var "key"])};
                        Odoc_model.Lang.Signature.Value
                         {Odoc_model.Lang.Value.id =
                           `Value
                             (`Root (Common.root, "Base__Array"),
                              "binary_search_segmented");
                          doc = [];
                          type_ =
                           Odoc_model.Lang.TypeExpr.Constr
                            (`Resolved
                               (`Type
                                  (`Canonical
                                     (`Module (`Hidden ...),
                                        `Dot (`Root ...)),
                                      "binary_search_segmented")),
                                [Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier (`Type (`Root (...), "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]);
                                 Odoc_model.Lang.TypeExpr.Var "a"])}]}};
                    Odoc_model.Lang.Signature.Include
                     {Odoc_model.Lang.Include.parent =
                       `Root (Common.root, "Base__Array");
                      doc = [];
                      decl =
                       Odoc_model.Lang.Module.ModuleType
                        (Odoc_model.Lang.ModuleType.With
                          (Odoc_model.Lang.ModuleType.Path
                            (`Resolved
                               (`ModuleType
                                  (`Canonical
                                     (`Module
                                        (`Hidden (`Identifier (`Root ...)),
                                           "Container"),
                                        `Dot (`Root "Base", "Container")),
                                     "S1"))),
                            [Odoc_model.Lang.ModuleType.TypeSubst
                              (`Resolved (`Type (`Root, "t")),
                              {Odoc_model.Lang.TypeDecl.Equation.params =
                                [(Odoc_model.Lang.TypeDecl.Var "a", None)];
                               private_ = false;
                               manifest =
                                Some
                                 (Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`Type (`Root (...), "t"))),
                                   [Odoc_model.Lang.TypeExpr.Var "a"]));
                               constraints = []})]));
                       expansion =
                        {Odoc_model.Lang.Include.resolved = true;
                         content =
                          [Odoc_model.Lang.Signature.Value
                            {Odoc_model.Lang.Value.id =
                              `Value
                                (`Root (Common.root, "Base__Array"), "mem");
                             doc = [];
                             type_ =
                              Odoc_model.Lang.TypeExpr.Arrow (None,
                               Odoc_model.Lang.TypeExpr.Constr
                                (`Resolved
                                   (`Identifier
                                      (`Type
                                         (`Root (Common.root, "Base__Array"),
                                          "t"))),
                                [Odoc_model.Lang.TypeExpr.Var "a"]),
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Var "a",
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some
                                   (Odoc_model.Lang.TypeExpr.Label "equal"),
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Var "a",
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "a",
                                   Odoc_model.Lang.TypeExpr.Constr
                                    (`Resolved (`Identifier (`CoreType ...)),
                                       []))),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "bool")),
                                   []))))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "length");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved (`Identifier (`CoreType "int")),
                                 []))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "is_empty");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved (`Identifier (`CoreType "bool")),
                                 []))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"), "iter");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Var "a",
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "unit")),
                                   [])),
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved (`Identifier (`CoreType "unit")),
                                  [])))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"), "fold");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some
                                   (Odoc_model.Lang.TypeExpr.Label "init"),
                                 Odoc_model.Lang.TypeExpr.Var "accum",
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "accum",
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "a",
                                    Odoc_model.Lang.TypeExpr.Var "accum")),
                                  Odoc_model.Lang.TypeExpr.Var "accum")))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "fold_result");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some
                                   (Odoc_model.Lang.TypeExpr.Label "init"),
                                 Odoc_model.Lang.TypeExpr.Var "accum",
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "accum",
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "a",
                                    Odoc_model.Lang.TypeExpr.Constr
                                     (`Resolved (`Type (...)),
                                     [Odoc_model.Lang.TypeExpr.Var "accum";
                                      Odoc_model.Lang.TypeExpr.Var "e"]))),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved (`Type (`Canonical (...), "t")),
                                   [Odoc_model.Lang.TypeExpr.Var "accum";
                                    Odoc_model.Lang.TypeExpr.Var "e"]))))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "fold_until");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some
                                   (Odoc_model.Lang.TypeExpr.Label "init"),
                                 Odoc_model.Lang.TypeExpr.Var "accum",
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "accum",
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "a",
                                    Odoc_model.Lang.TypeExpr.Constr
                                     (`Resolved (`Type (...)),
                                     [Odoc_model.Lang.TypeExpr.Var "accum";
                                      Odoc_model.Lang.TypeExpr.Var "final"]))),
                                  Odoc_model.Lang.TypeExpr.Arrow
                                   (Some
                                     (Odoc_model.Lang.TypeExpr.Label "finish"),
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "accum",
                                    Odoc_model.Lang.TypeExpr.Var "final"),
                                   Odoc_model.Lang.TypeExpr.Var "final"))))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "exists");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Var "a",
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "bool")),
                                   [])),
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved (`Identifier (`CoreType "bool")),
                                  [])))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "for_all");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Var "a",
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "bool")),
                                   [])),
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved (`Identifier (`CoreType "bool")),
                                  [])))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"),
                                  "count");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Constr
                                 (`Resolved
                                    (`Identifier
                                       (`Type
                                          (`Root (Common.root, "Base__Array"),
                                           "t"))),
                                 [Odoc_model.Lang.TypeExpr.Var "a"]),
                                Odoc_model.Lang.TypeExpr.Arrow
                                 (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Var "a",
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "bool")),
                                   [])),
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved (`Identifier (`CoreType "int")),
                                  [])))};
                            Odoc_model.Lang.Signature.Value
                             {Odoc_model.Lang.Value.id =
                               `Value
                                 (`Root (Common.root, "Base__Array"), "sum");
                              doc = [];
                              type_ =
                               Odoc_model.Lang.TypeExpr.Arrow (None,
                                Odoc_model.Lang.TypeExpr.Package
                                 {Odoc_model.Lang.TypeExpr.Package.path =
                                   `Resolved
                                     (`ModuleType
                                        (`Canonical (`Module ...),
                                           "Summable"));
                                   substitutions =
                                    [(`Resolved (`Type (`Root, "t")),
                                      Odoc_model.Lang.TypeExpr.Var "sum")]},
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`Type (`Root (...), "t"))),
                                   [Odoc_model.Lang.TypeExpr.Var "a"]),
                                  Odoc_model.Lang.TypeExpr.Arrow
                                   (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "a",
                                    Odoc_model.Lang.TypeExpr.Var "sum"),
                                   Odoc_model.Lang.TypeExpr.Var "sum")))};
                             Odoc_model.Lang.Signature.Value
                              {Odoc_model.Lang.Value.id =
                                `Value
                                  (`Root (Common.root, "Base__Array"),
                                   "find");
                               doc = [];
                               type_ =
                                Odoc_model.Lang.TypeExpr.Arrow (None,
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier
                                        (`Type
                                           (`Root
                                              (Common.root, "Base__Array"),
                                            "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]),
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "a",
                                   Odoc_model.Lang.TypeExpr.Constr
                                    (`Resolved
                                       (`Identifier (`CoreType "bool")),
                                    [])),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "option")),
                                   [Odoc_model.Lang.TypeExpr.Var "a"])))};
                             Odoc_model.Lang.Signature.Value
                              {Odoc_model.Lang.Value.id =
                                `Value
                                  (`Root (Common.root, "Base__Array"),
                                   "find_map");
                               doc = [];
                               type_ =
                                Odoc_model.Lang.TypeExpr.Arrow (None,
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier
                                        (`Type
                                           (`Root
                                              (Common.root, "Base__Array"),
                                            "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]),
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some (Odoc_model.Lang.TypeExpr.Label "f"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "a",
                                   Odoc_model.Lang.TypeExpr.Constr
                                    (`Resolved
                                       (`Identifier (`CoreType "option")),
                                    [Odoc_model.Lang.TypeExpr.Var "b"])),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "option")),
                                   [Odoc_model.Lang.TypeExpr.Var "b"])))};
                             Odoc_model.Lang.Signature.Value
                              {Odoc_model.Lang.Value.id =
                                `Value
                                  (`Root (Common.root, "Base__Array"),
                                   "to_list");
                               doc = [];
                               type_ =
                                Odoc_model.Lang.TypeExpr.Arrow (None,
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier
                                        (`Type
                                           (`Root
                                              (Common.root, "Base__Array"),
                                            "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]),
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved (`Identifier (`CoreType "list")),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]))};
                             Odoc_model.Lang.Signature.Value
                              {Odoc_model.Lang.Value.id =
                                `Value
                                  (`Root (Common.root, "Base__Array"),
                                   "to_array");
                               doc = [];
                               type_ =
                                Odoc_model.Lang.TypeExpr.Arrow (None,
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier
                                        (`Type
                                           (`Root
                                              (Common.root, "Base__Array"),
                                            "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]),
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier (`CoreType "array")),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]))};
                             Odoc_model.Lang.Signature.Value
                              {Odoc_model.Lang.Value.id =
                                `Value
                                  (`Root (Common.root, "Base__Array"),
                                   "min_elt");
                               doc = [];
                               type_ =
                                Odoc_model.Lang.TypeExpr.Arrow (None,
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier
                                        (`Type
                                           (`Root
                                              (Common.root, "Base__Array"),
                                            "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]),
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some
                                    (Odoc_model.Lang.TypeExpr.Label "compare"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "a",
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "a",
                                    Odoc_model.Lang.TypeExpr.Constr
                                     (`Resolved
                                        (`Identifier (`CoreType "int")),
                                     []))),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "option")),
                                   [Odoc_model.Lang.TypeExpr.Var "a"])))};
                             Odoc_model.Lang.Signature.Value
                              {Odoc_model.Lang.Value.id =
                                `Value
                                  (`Root (Common.root, "Base__Array"),
                                   "max_elt");
                               doc = [];
                               type_ =
                                Odoc_model.Lang.TypeExpr.Arrow (None,
                                 Odoc_model.Lang.TypeExpr.Constr
                                  (`Resolved
                                     (`Identifier
                                        (`Type
                                           (`Root
                                              (Common.root, "Base__Array"),
                                            "t"))),
                                  [Odoc_model.Lang.TypeExpr.Var "a"]),
                                 Odoc_model.Lang.TypeExpr.Arrow
                                  (Some
                                    (Odoc_model.Lang.TypeExpr.Label "compare"),
                                  Odoc_model.Lang.TypeExpr.Arrow (None,
                                   Odoc_model.Lang.TypeExpr.Var "a",
                                   Odoc_model.Lang.TypeExpr.Arrow (None,
                                    Odoc_model.Lang.TypeExpr.Var "a",
                                    Odoc_model.Lang.TypeExpr.Constr
                                     (`Resolved
                                        (`Identifier (`CoreType "int")),
                                     []))),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Identifier (`CoreType "option")),
                                   [Odoc_model.Lang.TypeExpr.Var "a"])))}]}};
                       Odoc_model.Lang.Signature.Include
                        {Odoc_model.Lang.Include.parent =
                          `Root (Common.root, "Base__Array");
                         doc = [];
                         decl =
                          Odoc_model.Lang.Module.ModuleType
                           (Odoc_model.Lang.ModuleType.With
                             (Odoc_model.Lang.ModuleType.Path
                               (`Resolved
                                  (`ModuleType
                                     (`Canonical
                                        (`Module
                                           (`Hidden
                                              (`Identifier (`Root ...)),
                                              "Invariant"),
                                           `Dot (`Root "Base", "Invariant")),
                                        "S1"))),
                               [Odoc_model.Lang.ModuleType.TypeSubst
                                 (`Resolved (`Type (`Root, "t")),
                                 {Odoc_model.Lang.TypeDecl.Equation.params =
                                   [(Odoc_model.Lang.TypeDecl.Var "a", None)];
                                  private_ = false;
                                  manifest =
                                   Some
                                    (Odoc_model.Lang.TypeExpr.Constr
                                      (`Resolved
                                         (`Identifier
                                            (`Type (`Root (...), "t"))),
                                      [Odoc_model.Lang.TypeExpr.Var "a"]));
                                  constraints = []})]));
                          expansion =
                           {Odoc_model.Lang.Include.resolved = true;
                            content =
                             [Odoc_model.Lang.Signature.Value
                               {Odoc_model.Lang.Value.id =
                                 `Value
                                   (`Root (Common.root, "Base__Array"),
                                    "invariant");
                                doc = [];
                                type_ =
                                 Odoc_model.Lang.TypeExpr.Arrow (None,
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Type
                                         (`Canonical
                                            (`Module (...), `Dot (...)),
                                          "inv")),
                                   [Odoc_model.Lang.TypeExpr.Var "a"]),
                                  Odoc_model.Lang.TypeExpr.Constr
                                   (`Resolved
                                      (`Type
                                         (`Canonical
                                            (`Module (...), `Dot (...)),
                                          "inv")),
                                   [Odoc_model.Lang.TypeExpr.Constr
                                     (`Resolved
                                        (`Identifier (`Type (`Root ...))),
                                        [Odoc_model.Lang.TypeExpr.Var "a"])]))}]}};
                         Odoc_model.Lang.Signature.Value
                          {Odoc_model.Lang.Value.id =
                            `Value
                              (`Root (Common.root, "Base__Array"),
                               "max_length");
                           doc =
                            [{Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 20; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 21;
                                  column = 74}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 11}};
                                   value = `Word "Maximum"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 12}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 12};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 18}};
                                   value = `Word "length"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 18};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 19}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 21}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 23}};
                                   value = `Word "a"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 23};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 24}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 24};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 30}};
                                   value = `Word "normal"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 30};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 31}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 37}};
                                   value = `Word "array."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 37};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 39}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 39};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 42}};
                                   value = `Word "The"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 42};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 43}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 43};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 50}};
                                   value = `Word "maximum"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 51}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 51};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 57}};
                                   value = `Word "length"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 57};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 58}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 58};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 60}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 60};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 61}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 61};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 62}};
                                   value = `Word "a"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 62};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 63}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 63};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 68}};
                                   value = `Word "float"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 68};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 69}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 69};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 74}};
                                   value = `Word "array"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 74};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 75}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 75};
                                     end_ =
                                      {Odoc_model.Location_.line = 20;
                                       column = 77}};
                                   value = `Word "is"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 20;
                                       column = 77};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 18}};
                                   value = `Code_span "max_length/2"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 18};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 19}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 21}};
                                   value = `Word "on"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 28}};
                                   value = `Word "32-bit"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 28};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 29}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 29};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 37}};
                                   value = `Word "machines"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 37};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 38}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 38};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 41}};
                                   value = `Word "and"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 41};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 42}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 42};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 54}};
                                   value = `Code_span "max_length"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 54};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 55}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 55};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 57}};
                                   value = `Word "on"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 57};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 58}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 58};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 64}};
                                   value = `Word "64-bit"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 64};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 65}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 21;
                                       column = 65};
                                     end_ =
                                      {Odoc_model.Location_.line = 21;
                                       column = 74}};
                                   value = `Word "machines."}]}];
                           type_ =
                            Odoc_model.Lang.TypeExpr.Constr
                             (`Resolved (`Identifier (`CoreType "int")), 
                             [])};
                         Odoc_model.Lang.Signature.External
                          {Odoc_model.Lang.External.id =
                            `Value
                              (`Root (Common.root, "Base__Array"), "get");
                           doc =
                            [{Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 24; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 27;
                                  column = 58}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 19}};
                                   value = `Code_span "Array.get a n"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 20}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 20};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 27}};
                                   value = `Word "returns"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 27};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 28}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 28};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 31}};
                                   value = `Word "the"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 32}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 32};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 39}};
                                   value = `Word "element"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 39};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 40}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 40};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 46}};
                                   value = `Word "number"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 46};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 47}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 47};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 50}};
                                   value = `Code_span "n"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 51}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 51};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 53}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 53};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 54}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 54};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 59}};
                                   value = `Word "array"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 59};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 60}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 60};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 63}};
                                   value = `Code_span "a"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 63};
                                     end_ =
                                      {Odoc_model.Location_.line = 24;
                                       column = 64}};
                                   value = `Word "."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 24;
                                       column = 64};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 7}};
                                   value = `Word "The"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 7};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 8}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 8};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 13}};
                                   value = `Word "first"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 13};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 14}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 14};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 21}};
                                   value = `Word "element"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 25}};
                                   value = `Word "has"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 25};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 26}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 26};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 32}};
                                   value = `Word "number"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 32};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 33}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 33};
                                     end_ =
                                      {Odoc_model.Location_.line = 25;
                                       column = 35}};
                                   value = `Word "0."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 25;
                                       column = 35};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 7}};
                                   value = `Word "The"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 7};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 8}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 8};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 12}};
                                   value = `Word "last"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 12};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 13}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 13};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 20}};
                                   value = `Word "element"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 20};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 21}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 24}};
                                   value = `Word "has"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 24};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 25}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 25};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 31}};
                                   value = `Word "number"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 32}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 32};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 52}};
                                   value = `Code_span "Array.length a - 1"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 52};
                                     end_ =
                                      {Odoc_model.Location_.line = 26;
                                       column = 53}};
                                   value = `Word "."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 26;
                                       column = 53};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 7}};
                                   value = `Word "You"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 7};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 8}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 8};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 11}};
                                   value = `Word "can"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 12}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 12};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 16}};
                                   value = `Word "also"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 16};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 17}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 17};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 22}};
                                   value = `Word "write"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 23}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 23};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 30}};
                                   value = `Code_span "a.(n)"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 30};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 31}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 38}};
                                   value = `Word "instead"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 38};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 39}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 39};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 41}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 41};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 42}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 42};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 57}};
                                   value = `Code_span "Array.get a n"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 27;
                                       column = 57};
                                     end_ =
                                      {Odoc_model.Location_.line = 27;
                                       column = 58}};
                                   value = `Word "."}]};
                             {Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 29; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 30;
                                  column = 60}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 29;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 29;
                                       column = 9}};
                                   value = `Word "Raise"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 29;
                                       column = 9};
                                     end_ =
                                      {Odoc_model.Location_.line = 29;
                                       column = 10}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 29;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 29;
                                       column = 50}};
                                   value =
                                    `Code_span
                                      "Invalid_argument \"index out of bounds\""};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 29;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 6}};
                                   value = `Word "if"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 6};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 7}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 7};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 10}};
                                   value = `Code_span "n"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 11}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 13}};
                                   value = `Word "is"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 13};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 14}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 14};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 21}};
                                   value = `Word "outside"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 25}};
                                   value = `Word "the"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 25};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 26}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 26};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 31}};
                                   value = `Word "range"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 32}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 32};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 33}};
                                   value = `Word "0"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 33};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 34}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 34};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 36}};
                                   value = `Word "to"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 36};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 37}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 37};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 59}};
                                   value = `Code_span "(Array.length a - 1)"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 30;
                                       column = 59};
                                     end_ =
                                      {Odoc_model.Location_.line = 30;
                                       column = 60}};
                                   value = `Word "."}]}];
                           type_ =
                            Odoc_model.Lang.TypeExpr.Arrow (None,
                             Odoc_model.Lang.TypeExpr.Constr
                              (`Resolved
                                 (`Identifier
                                    (`Type
                                       (`Root (Common.root, "Base__Array"),
                                        "t"))),
                              [Odoc_model.Lang.TypeExpr.Var "a"]),
                             Odoc_model.Lang.TypeExpr.Arrow (None,
                              Odoc_model.Lang.TypeExpr.Constr
                               (`Resolved (`Identifier (`CoreType "int")),
                               []),
                              Odoc_model.Lang.TypeExpr.Var "a"));
                           primitives = ["%array_safe_get"]};
                         Odoc_model.Lang.Signature.External
                          {Odoc_model.Lang.External.id =
                            `Value
                              (`Root (Common.root, "Base__Array"), "set");
                           doc =
                            [{Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 33; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 35;
                                  column = 65}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 21}};
                                   value = `Code_span "Array.set a n x"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 30}};
                                   value = `Word "modifies"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 30};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 31}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 36}};
                                   value = `Word "array"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 36};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 37}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 37};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 40}};
                                   value = `Code_span "a"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 40};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 41}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 41};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 43}};
                                   value = `Word "in"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 43};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 44}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 44};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 50}};
                                   value = `Word "place,"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 51}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 51};
                                     end_ =
                                      {Odoc_model.Location_.line = 33;
                                       column = 60}};
                                   value = `Word "replacing"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 33;
                                       column = 60};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 11}};
                                   value = `Word "element"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 12}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 12};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 18}};
                                   value = `Word "number"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 18};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 19}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 22}};
                                   value = `Code_span "n"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 23}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 23};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 27}};
                                   value = `Word "with"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 27};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 28}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 28};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 31}};
                                   value = `Code_span "x"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 34;
                                       column = 32}};
                                   value = `Word "."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 34;
                                       column = 32};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 7}};
                                   value = `Word "You"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 7};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 8}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 8};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 11}};
                                   value = `Word "can"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 12}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 12};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 16}};
                                   value = `Word "also"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 16};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 17}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 17};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 22}};
                                   value = `Word "write"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 23}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 23};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 35}};
                                   value = `Code_span "a.(n) <- x"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 35};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 36}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 36};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 43}};
                                   value = `Word "instead"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 43};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 44}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 44};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 46}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 46};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 47}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 47};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 64}};
                                   value = `Code_span "Array.set a n x"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 35;
                                       column = 64};
                                     end_ =
                                      {Odoc_model.Location_.line = 35;
                                       column = 65}};
                                   value = `Word "."}]};
                             {Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 37; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 38;
                                  column = 58}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 37;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 37;
                                       column = 9}};
                                   value = `Word "Raise"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 37;
                                       column = 9};
                                     end_ =
                                      {Odoc_model.Location_.line = 37;
                                       column = 10}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 37;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 37;
                                       column = 50}};
                                   value =
                                    `Code_span
                                      "Invalid_argument \"index out of bounds\""};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 37;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 6}};
                                   value = `Word "if"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 6};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 7}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 7};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 10}};
                                   value = `Code_span "n"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 11}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 13}};
                                   value = `Word "is"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 13};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 14}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 14};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 21}};
                                   value = `Word "outside"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 25}};
                                   value = `Word "the"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 25};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 26}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 26};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 31}};
                                   value = `Word "range"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 32}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 32};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 33}};
                                   value = `Word "0"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 33};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 34}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 34};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 36}};
                                   value = `Word "to"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 36};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 37}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 37};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 57}};
                                   value = `Code_span "Array.length a - 1"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 38;
                                       column = 57};
                                     end_ =
                                      {Odoc_model.Location_.line = 38;
                                       column = 58}};
                                   value = `Word "."}]}];
                           type_ =
                            Odoc_model.Lang.TypeExpr.Arrow (None,
                             Odoc_model.Lang.TypeExpr.Constr
                              (`Resolved
                                 (`Identifier
                                    (`Type
                                       (`Root (Common.root, "Base__Array"),
                                        "t"))),
                              [Odoc_model.Lang.TypeExpr.Var "a"]),
                             Odoc_model.Lang.TypeExpr.Arrow (None,
                              Odoc_model.Lang.TypeExpr.Constr
                               (`Resolved (`Identifier (`CoreType "int")),
                               []),
                              Odoc_model.Lang.TypeExpr.Arrow (None,
                               Odoc_model.Lang.TypeExpr.Var "a",
                               Odoc_model.Lang.TypeExpr.Constr
                                (`Resolved (`Identifier (`CoreType "unit")),
                                []))));
                           primitives = ["%array_safe_set"]};
                         Odoc_model.Lang.Signature.External
                          {Odoc_model.Lang.External.id =
                            `Value
                              (`Root (Common.root, "Base__Array"),
                               "unsafe_get");
                           doc =
                            [{Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 41; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 42;
                                  column = 17}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 10}};
                                   value = `Word "Unsafe"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 11}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 18}};
                                   value = `Word "version"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 18};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 19}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 21}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 27}};
                                   value = `Code_span "get"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 27};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 28}};
                                   value = `Word "."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 28};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 30}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 30};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 33}};
                                   value = `Word "Can"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 33};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 34}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 34};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 39}};
                                   value = `Word "cause"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 39};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 40}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 40};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 49}};
                                   value = `Word "arbitrary"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 49};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 50}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 58}};
                                   value = `Word "behavior"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 58};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 59}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 59};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 63}};
                                   value = `Word "when"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 63};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 64}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 64};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 68}};
                                   value = `Word "used"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 68};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 69}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 69};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 72}};
                                   value = `Word "for"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 72};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 73}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 73};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 75}};
                                   value = `Word "an"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 75};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 76}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 76};
                                     end_ =
                                      {Odoc_model.Location_.line = 41;
                                       column = 89}};
                                   value = `Word "out-of-bounds"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 41;
                                       column = 89};
                                     end_ =
                                      {Odoc_model.Location_.line = 42;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 42;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 42;
                                       column = 9}};
                                   value = `Word "array"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 42;
                                       column = 9};
                                     end_ =
                                      {Odoc_model.Location_.line = 42;
                                       column = 10}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 42;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 42;
                                       column = 17}};
                                   value = `Word "access."}]}];
                           type_ =
                            Odoc_model.Lang.TypeExpr.Arrow (None,
                             Odoc_model.Lang.TypeExpr.Constr
                              (`Resolved
                                 (`Identifier
                                    (`Type
                                       (`Root (Common.root, "Base__Array"),
                                        "t"))),
                              [Odoc_model.Lang.TypeExpr.Var "a"]),
                             Odoc_model.Lang.TypeExpr.Arrow (None,
                              Odoc_model.Lang.TypeExpr.Constr
                               (`Resolved (`Identifier (`CoreType "int")),
                               []),
                              Odoc_model.Lang.TypeExpr.Var "a"));
                           primitives = ["%array_unsafe_get"]};
                         Odoc_model.Lang.Signature.External
                          {Odoc_model.Lang.External.id =
                            `Value
                              (`Root (Common.root, "Base__Array"),
                               "unsafe_set");
                           doc =
                            [{Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 45; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 46;
                                  column = 17}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 10}};
                                   value = `Word "Unsafe"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 11}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 11};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 18}};
                                   value = `Word "version"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 18};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 19}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 21}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 21};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 22}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 22};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 27}};
                                   value = `Code_span "set"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 27};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 28}};
                                   value = `Word "."};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 28};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 30}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 30};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 33}};
                                   value = `Word "Can"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 33};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 34}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 34};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 39}};
                                   value = `Word "cause"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 39};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 40}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 40};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 49}};
                                   value = `Word "arbitrary"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 49};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 50}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 50};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 58}};
                                   value = `Word "behavior"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 58};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 59}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 59};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 63}};
                                   value = `Word "when"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 63};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 64}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 64};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 68}};
                                   value = `Word "used"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 68};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 69}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 69};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 72}};
                                   value = `Word "for"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 72};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 73}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 73};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 75}};
                                   value = `Word "an"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 75};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 76}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 76};
                                     end_ =
                                      {Odoc_model.Location_.line = 45;
                                       column = 89}};
                                   value = `Word "out-of-bounds"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 45;
                                       column = 89};
                                     end_ =
                                      {Odoc_model.Location_.line = 46;
                                       column = 4}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 46;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 46;
                                       column = 9}};
                                   value = `Word "array"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 46;
                                       column = 9};
                                     end_ =
                                      {Odoc_model.Location_.line = 46;
                                       column = 10}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 46;
                                       column = 10};
                                     end_ =
                                      {Odoc_model.Location_.line = 46;
                                       column = 17}};
                                   value = `Word "access."}]}];
                           type_ =
                            Odoc_model.Lang.TypeExpr.Arrow (None,
                             Odoc_model.Lang.TypeExpr.Constr
                              (`Resolved
                                 (`Identifier
                                    (`Type
                                       (`Root (Common.root, "Base__Array"),
                                        "t"))),
                              [Odoc_model.Lang.TypeExpr.Var "a"]),
                             Odoc_model.Lang.TypeExpr.Arrow (None,
                              Odoc_model.Lang.TypeExpr.Constr
                               (`Resolved (`Identifier (`CoreType "int")),
                               []),
                              Odoc_model.Lang.TypeExpr.Arrow (None,
                               Odoc_model.Lang.TypeExpr.Var "a",
                               Odoc_model.Lang.TypeExpr.Constr
                                (`Resolved (`Identifier (`CoreType "unit")),
                                []))));
                           primitives = ["%array_unsafe_set"]};
                         Odoc_model.Lang.Signature.Value
                          {Odoc_model.Lang.Value.id =
                            `Value
                              (`Root (Common.root, "Base__Array"), "create");
                           doc =
                            [{Odoc_model.Location_.location =
                               {Odoc_model.Location_.file = "src/array.mli";
                                start =
                                 {Odoc_model.Location_.line = 49; column = 4};
                                end_ =
                                 {Odoc_model.Location_.line = 50;
                                  column = 17}};
                              value =
                               `Paragraph
                                 [{Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 4};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 19}};
                                   value = `Code_span "create ~len x"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 19};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 20}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 20};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 27}};
                                   value = `Word "creates"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 27};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 28}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 28};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 30}};
                                   value = `Word "an"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 30};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 31}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 31};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 36}};
                                   value = `Word "array"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 36};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 37}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 37};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 39}};
                                   value = `Word "of"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 39};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 40}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 40};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 46}};
                                   value = `Word "length"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 46};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 47}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 47};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 52}};
                                   value = `Code_span "len"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 52};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 53}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 53};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 57}};
                                   value = `Word "with"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 57};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 58}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 58};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 61}};
                                   value = `Word "the"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 61};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 62}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 62};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 67}};
                                   value = `Word "value"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 67};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 68}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 68};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 71}};
                                   value = `Code_span "x"};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/array.mli";
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 71};
                                     end_ =
                                      {Odoc_model.Location_.line = 49;
                                       column = 72}};
                                   value = `Space};
                                  {Odoc_model.Location_.location =
                                    {Odoc_model.Location_.file =
                                      "src/"... (* string length 13; truncated *);
                                     start =
                                      {Odoc_model.Location_.line = 49;
                                       column = 72};
                                     end_ =
                                      {Odoc_model.Location_.line = ...;
                                       column = ...}};
                                   value = ...};
                                  ...]};
                             ...];
                           type_ = ...};
                         ...]
```
