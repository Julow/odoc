let strict_mode = ref false

type kind = [ `Root | `Internal | `Warning ]

type loc = Odoc_model.Location_.span

type context = loc * string * string option
(** Location * message * suggestion *)

type 'a with_failures = 'a * (kind * string * loc option * context option) list

let failure_acc = ref []

let loc_acc = ref None

let context_acc = ref None

let add ~kind f =
  failure_acc := (kind, f, !loc_acc, !context_acc) :: !failure_acc

let with_var var x f =
  let prev_x = !var in
  var := x;
  let r = f () in
  let last_x = !var in
  var := prev_x;
  (r, last_x)

let catch_failures f =
  let r, failures = with_var failure_acc [] f in
  (r, List.rev failures)

let kasprintf k fmt =
  Format.(kfprintf (fun _ -> k (flush_str_formatter ())) str_formatter fmt)

(** Report a lookup failure to the enclosing [catch_failures] call. *)
let report ?(kind = `Internal) fmt = kasprintf (add ~kind) fmt

(** Like [report] above but may raise the exception [exn] if strict mode is enabled *)
let report_important ?(kind = `Internal) exn fmt =
  if !strict_mode then raise exn else kasprintf (add ~kind) fmt

let with_location loc f = fst (with_var loc_acc (Some loc) f)

let with_context ?suggestion loc msg f =
  fst (with_var context_acc (Some (loc, msg, suggestion)) f)

let handle_failures ~warn_error ~filename (r, failures) =
  let open Odoc_model in
  let error ~loc msg =
    match loc with
    | Some loc -> Error.make "%s" msg loc
    | None -> Error.filename_only "%s" msg filename
  in
  let handle_failure ~warnings (kind, msg, loc, context) =
    let e = error ~loc msg in
    let e =
      match context with
      | None -> e
      | Some (cloc, cmsg, suggestion) ->
          Error.make ?suggestion "The following error occurred while %s:@\n%s"
            cmsg (Error.to_string e) cloc
    in
    match kind with
    | `Internal -> Error.warning warnings e
    | `Warning -> Error.warning warnings e
    | `Root -> prerr_endline (Error.to_string e)
  in
  Error.accumulate_warnings (fun warnings ->
      List.iter (handle_failure ~warnings) failures;
      r)
  |> Error.handle_warnings ~warn_error
