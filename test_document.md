# Discovering how odoc_document works

```ocaml
(* Prelude *)
#require "odoc.xref_test";;

open Odoc_document

(** Compile an input and returns the corresponding document. *)
let document_of_mli input =
  Odoc_xref_test.Common.resolve_from_string input
  |> Renderer.document_of_compilation_unit ~syntax:Renderer.OCaml

open Types
```

Variant:

```ocaml
# document_of_mli "(** Doc t. *) type t = Foo (** Doc Foo. *) | Bar"
- : Page.t =
{Odoc_document.Types.Page.title = "Root";
 header =
  [Odoc_document.Types.Item.Heading
    {Odoc_document.Types.Heading.label = None; level = 0;
     title =
      [{Odoc_document.Types.Inline.attr = [];
        desc = Odoc_document.Types.Inline.Text "Module "};
       {Odoc_document.Types.Inline.attr = [];
        desc =
         Odoc_document.Types.Inline.Source
          [Odoc_document.Types.Source.Tag (None,
            [Odoc_document.Types.Source.Elt
              [{Odoc_document.Types.Inline.attr = [];
                desc = Odoc_document.Types.Inline.Text ""}];
             Odoc_document.Types.Source.Elt
              [{Odoc_document.Types.Inline.attr = [];
                desc = Odoc_document.Types.Inline.Text "Root"}]]);
           Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text ""}]]}]}];
 items =
  [Odoc_document.Types.Item.Declaration
    {Odoc_document.Types.Item.attr = ["type"];
     anchor =
      Some
       {Odoc_document.Url.Anchor.page =
         {Odoc_document.Url.Path.kind = `Module;
          parent =
           Some
            {Odoc_document.Url.Path.kind = `Page; parent = None;
             name = "None"};
          name = "Root"};
        anchor = "type-t"; kind = `Type};
     content =
      [Odoc_document.Types.DocumentedSrc.Code
        [Odoc_document.Types.Source.Tag (None,
          [Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text ""}];
           Odoc_document.Types.Source.Tag (Some "keyword",
            [Odoc_document.Types.Source.Elt
              [{Odoc_document.Types.Inline.attr = [];
                desc = Odoc_document.Types.Inline.Text ""}];
             Odoc_document.Types.Source.Elt
              [{Odoc_document.Types.Inline.attr = [];
                desc = Odoc_document.Types.Inline.Text "type"}]]);
           Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text ""}];
           Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text " "}];
           Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text "t"}]]);
         Odoc_document.Types.Source.Elt
          [{Odoc_document.Types.Inline.attr = [];
            desc = Odoc_document.Types.Inline.Text ""}]];
       Odoc_document.Types.DocumentedSrc.Code
        [Odoc_document.Types.Source.Tag (None,
          [Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text ""}]]);
         Odoc_document.Types.Source.Elt
          [{Odoc_document.Types.Inline.attr = [];
            desc = Odoc_document.Types.Inline.Text ""}]];
       Odoc_document.Types.DocumentedSrc.Code
        [Odoc_document.Types.Source.Tag (None,
          [Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text ""}];
           Odoc_document.Types.Source.Elt
            [{Odoc_document.Types.Inline.attr = [];
              desc = Odoc_document.Types.Inline.Text " = "}]]);
         Odoc_document.Types.Source.Elt
          [{Odoc_document.Types.Inline.attr = [];
            desc = Odoc_document.Types.Inline.Text ""}]];
       Odoc_document.Types.DocumentedSrc.Nested
        {Odoc_document.Types.DocumentedSrc.attrs =
          ["def"; "variant"; "constructor"];
         anchor =
          Some
           {Odoc_document.Url.Anchor.page =
             {Odoc_document.Url.Path.kind = `Module;
              parent =
               Some
                {Odoc_document.Url.Path.kind = `Page; parent = None;
                 name = "None"};
              name = "Root"};
            anchor = "type-t.Foo"; kind = `Constructor};
         code =
          [Odoc_document.Types.DocumentedSrc.Code
            [Odoc_document.Types.Source.Tag (None,
              [Odoc_document.Types.Source.Elt
                [{Odoc_document.Types.Inline.attr = [];
                  desc = Odoc_document.Types.Inline.Text ""}];
               Odoc_document.Types.Source.Elt
                [{Odoc_document.Types.Inline.attr = [];
                  desc = Odoc_document.Types.Inline.Text "| "}]]);
             Odoc_document.Types.Source.Elt
              [{Odoc_document.Types.Inline.attr = [];
                desc = Odoc_document.Types.Inline.Text ""}]];
           Odoc_document.Types.DocumentedSrc.Code
            [Odoc_document.Types.Source.Tag (None,
              [Odoc_document.Types.Source.Elt
                [{Odoc_document.Types.Inline.attr = [];
                  desc = Odoc_document.Types.Inline.Text ""}];
               Odoc_document.Types.Source.Tag (Some "constructor",
                [Odoc_document.Types.Source.Elt
                  [{Odoc_document.Types.Inline.attr = [];
                    desc = Odoc_document.Types.Inline.Text ""}];
                 Odoc_document.Types.Source.Elt
                  [{Odoc_document.Types.Inline.attr = [];
                    desc = Odoc_document.Types.Inline.Text "Foo"}]]);
               Odoc_document.Types.Source.Elt
                [{Odoc_document.Types.Inline.attr = [];
                  desc = Odoc_document.Types.Inline.Text ""}]]);
             ...];
           ...];
         doc = ...; markers = ...};
       ...];
     doc = ...};
   ...];
 url = ...}
```
