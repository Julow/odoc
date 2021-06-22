# Testing the scope of references

  $ compile a.mli shadowed.mli shadowed_through_open.mli
  File "a.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "shadowed.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "shadowed_through_open.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib

  $ jq_scan_references() { jq -c '.. | .["`Reference"]? | select(.)'; }

The references from a.mli, see the attached text to recognize them:

  $ odoc_print a.odocl | jq_scan_references
  [{"`Resolved":{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"A"]},"B"]}},"C"]}},[{"`Word":"Defined-below"}]]
  [{"`Resolved":{"`Module":[{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"A"]}},"B"]},"C"]}},[{"`Word":"Defined-below-but-absolute"}]]
  [{"`Root":["C","`TUnknown"]},[{"`Word":"Through-open"}]]
  [{"`Resolved":{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"A"]},"B"]}},"C"]}},[{"`Word":"Doc-relative"}]]
  [{"`Resolved":{"`Module":[{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"A"]}},"B"]},"C"]}},[{"`Word":"Doc-absolute"}]]

References should be resolved after the whole signature has been added to the
scope. Both "Before-shadowed" and "After-shadowed" should resolve to [M.t].

  $ odoc_print shadowed.odocl | jq_scan_references
  [{"`Resolved":{"`Identifier":{"`Type":[{"`Module":[{"`Root":[{"`RootPage":"test"},"Shadowed"]},"M"]},"t"]}}},[{"`Word":"Before-shadowed"}]]
  [{"`Resolved":{"`Type":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"Shadowed"]}},"t"]}},[]]
  [{"`Resolved":{"`Identifier":{"`Type":[{"`Module":[{"`Root":[{"`RootPage":"test"},"Shadowed"]},"M"]},"t"]}}},[{"`Word":"After-shadowed"}]]

"Before-open" and "After-open" should resolve to to [T.t].
"Before-include" and "After-include" should resolve to [Through_include.t].

  $ odoc_print shadowed_through_open.odocl | jq_scan_references
  [{"`Resolved":{"`Identifier":{"`Type":[{"`Root":[{"`RootPage":"test"},"Shadowed_through_open"]},"t"]}}},[{"`Word":"Before-open"}]]
  [{"`Resolved":{"`Identifier":{"`Type":[{"`Root":[{"`RootPage":"test"},"Shadowed_through_open"]},"t"]}}},[{"`Word":"After-open"}]]
  [{"`Resolved":{"`Identifier":{"`Type":[{"`Module":[{"`Root":[{"`RootPage":"test"},"Shadowed_through_open"]},"Through_include"]},"t"]}}},[{"`Word":"Before-include"}]]
  [{"`Resolved":{"`Identifier":{"`Type":[{"`Module":[{"`Root":[{"`RootPage":"test"},"Shadowed_through_open"]},"Through_include"]},"t"]}}},[{"`Word":"After-include"}]]
