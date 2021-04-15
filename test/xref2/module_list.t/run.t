# Testing {!modules:...} lists

  $ compile external.mli starts_with_open.mli main.mli
  File "external.mli", line 20, characters 4-36:
  The synopsis from this module contains references that won't be resolved when included in this list.
  File "main.mli", line 1, character 4 to line 3, character 47:
  The synopsis from this module contains references that won't be resolved when included in this list.
  File "main.mli", line 1, character 4 to line 3, character 47:
  The synopsis from this module contains references that won't be resolved when included in this list.

Everything should resolve:

  $ odoc_print main.odocl | jq -c '.. | .["`Modules"]? | select(.) | .[] | .[]'
  {"`Resolved":{"`Identifier":{"`Root":[{"`RootPage":"test"},"External"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"External"},{"`Word":"."}]}
  {"`Resolved":{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"External"]}},"X"]}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"X"},{"`Word":"."}]}
  {"`Resolved":{"`Identifier":{"`Root":[{"`RootPage":"test"},"Main"]}}}
  "None"
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Internal"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"Internal"},{"`Word":"."}]}
  {"`Resolved":{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Internal"]}},"Y"]}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Word":"Internal."},{"`Code_span":"X"},{"`Word":"."},"`Space",{"`Word":"An"},"`Space",{"`Word":"other"},"`Space",{"`Word":"sentence."}]}
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Z"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"Z"},{"`Word":"."}]}
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"F"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"F ()"},{"`Word":"."}]}
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Type_of"]}}}
  "None"
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Type_of_str"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"of"},"`Space",{"`Code_span":"Type_of_str"},{"`Word":"."}]}
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"With_type"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"T"},{"`Word":"."}]}
  {"`Resolved":{"`SubstAlias":[{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"External"]}},"X"]},{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Alias"]}}]}}
  "None"
  {"`Resolved":{"`SubstAlias":[{"`Canonical":[{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Internal"]}},"C1"]},{"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"C1"]}}}]},{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"C1"]}}]}}
  "None"
  {"`Resolved":{"`SubstAlias":[{"`Canonical":[{"`Module":[{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Internal"]}},"C2"]},{"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"C2"]}}}]},{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"C2"]}}]}}
  "None"
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Inline_include"]}}}
  {"Some":[{"`Word":"Doc"},"`Space",{"`Word":"for"},"`Space",{"`Code_span":"T"},{"`Word":"."}]}
  {"`Resolved":{"`Identifier":{"`Root":[{"`RootPage":"test"},"Starts_with_open"]}}}
  {"Some":[{"`Word":"Synopsis"},"`Space",{"`Word":"of"},"`Space",{"`Code_span":"Starts_with_open"},{"`Word":"."}]}
  {"`Resolved":{"`Identifier":{"`Module":[{"`Root":[{"`RootPage":"test"},"Main"]},"Resolve_synopsis"]}}}
  {"Some":[{"`Reference":[{"`Root":["t","`TUnknown"]},[]]}]}
  {"`Resolved":{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"External"]}},"Resolve_synopsis"]}}
  {"Some":[{"`Reference":[{"`Root":["t","`TUnknown"]},[]]}]}

References in the synopses above should be resolved.
'External' contains a module list too:

  $ odoc_print external.odocl | jq -c '.. | .["`Modules"]? | select(.) | .[] | .[]'
  {"`Resolved":{"`Module":[{"`Identifier":{"`Root":[{"`RootPage":"test"},"Main"]}},"Resolve_synopsis"]}}
  {"Some":[{"`Reference":[{"`Root":["t","`TUnknown"]},[]]}]}

'Type_of' and 'Alias' don't have a summary. `C1` and `C2` neither, we expect at least `C2` to have one.
