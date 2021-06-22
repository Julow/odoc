Two modules that reference each other:

  $ cat a.mli
  type t
  (** {!B} *)
  $ cat b.mli
  type t
  (** {!A} *)

  $ compile a.mli b.mli
  File "a.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "b.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib

Check that references are resolved:

  $ odoc_print a.odocl | jq '.content.Module.items[0].Type[1].doc[0]'
  {
    "`Paragraph": [
      {
        "`Reference": [
          {
            "`Resolved": {
              "`Identifier": {
                "`Root": [
                  {
                    "`RootPage": "test"
                  },
                  "B"
                ]
              }
            }
          },
          []
        ]
      }
    ]
  }
  $ odoc_print b.odocl | jq '.content.Module.items[0].Type[1].doc[0]'
  {
    "`Paragraph": [
      {
        "`Reference": [
          {
            "`Resolved": {
              "`Identifier": {
                "`Root": [
                  {
                    "`RootPage": "test"
                  },
                  "A"
                ]
              }
            }
          },
          []
        ]
      }
    ]
  }
