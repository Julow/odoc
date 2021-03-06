Two modules that reference each other:

  $ cat a.mli
  type t
  (** {!B} *)
  $ cat b.mli
  type t
  (** {!A} *)

  $ compile a.mli b.mli
  Starting link
  Starting link

Check that references are resolved:

  $ odoc_print a.odocl | jq '.content.Module[0].Type[1].doc[0][1]'
  {
    "`Paragraph": [
      [
        "a.mli 2:4 2:8",
        {
          "`Reference": [
            {
              "`Resolved": {
                "`Identifier": {
                  "`Root": [
                    "<root>",
                    "B"
                  ]
                }
              }
            },
            []
          ]
        }
      ]
    ]
  }
  $ odoc_print b.odocl | jq '.content.Module[0].Type[1].doc[0][1]'
  {
    "`Paragraph": [
      [
        "b.mli 2:4 2:8",
        {
          "`Reference": [
            {
              "`Resolved": {
                "`Identifier": {
                  "`Root": [
                    "<root>",
                    "A"
                  ]
                }
              }
            },
            []
          ]
        }
      ]
    ]
  }
