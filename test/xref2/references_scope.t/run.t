# Testing the scope of references

  $ compile a.mli
  File "a.mli", line 18, characters 6-24:
  Failed to resolve reference.

  $ jq_scan_references() { jq -c '.. | .["`Reference"]? | select(.)'; }

The references from a.mli, see the attached text to recognize them:

  $ odoc_print a.odocl | jq_scan_references
  [{"`Resolved":{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"A"]},"B"]}},"C"]}},[{"`Word":"Defined-below"}]]
  [{"`Resolved":{"`Module":[{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"A"]}},"B"]},"C"]}},[{"`Word":"Defined-below-but-absolute"}]]
  [{"`Root":["C","`TUnknown"]},[{"`Word":"Through-open"}]]
  [{"`Resolved":{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"A"]},"B"]}},"C"]}},[{"`Word":"Doc-relative"}]]
  [{"`Resolved":{"`Module":[{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"A"]}},"B"]},"C"]}},[{"`Word":"Doc-absolute"}]]
