A quick test to repro the issue found in #587

  $ ./build.sh
  File "odoc_bug__.cmt":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Odoc_bug__a_intf Odoc_bug__b Odoc_bug__b_intf
    Stdlib
  File "odoc_bug__a_intf.cmt":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "odoc_bug__b_intf.cmt":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "odoc_bug__b.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
  File "odoc_bug__c.cmti":
  Couldn't find some external dependencies:
    CamlinternalFormatBasics Stdlib
