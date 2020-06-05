let strict_mode = ref false

type acc = {
  failures : string list;
  warnings : Odoc_model.Error.t list;
}

let empty_acc = { failures = []; warnings = [] }

type 'a with_failures = 'a * acc

let failure_acc = ref empty_acc

let add_failure f =
  let acc = !failure_acc in
  failure_acc := { acc with failures = f :: acc.failures }

let catch_failures f =
  let prev = !failure_acc in
  failure_acc := empty_acc;
  let r = f () in
  let acc = !failure_acc in
  failure_acc := prev;
  (r, acc)

let kasprintf k fmt =
  Format.(kfprintf (fun _ -> k (flush_str_formatter ())) str_formatter fmt)

(** Report a lookup failure to the enclosing [catch_failures] call. *)
let report fmt = kasprintf add_failure fmt

(** Like [report] above but may raise the exception [exn] if strict mode is enabled *)
let report_important exn fmt =
  if !strict_mode then raise exn else kasprintf add_failure fmt

let report_warning w =
  let acc = !failure_acc in
  failure_acc := { acc with warnings = w :: acc.warnings }

let pp = Format.pp_print_string

let pp_failures ppf fs = List.iter (Format.fprintf ppf "%a@\n" pp) fs

let to_warning ~filename (r, { warnings; failures }) =
  let open Odoc_model.Error in
  accumulate_warnings (fun wacc ->
      List.iter (warning wacc) warnings;
      ( if failures <> [] then
        let failures = List.sort_uniq String.compare failures in
        warning wacc
          (filename_only "The following lookup failures occurred:@\n%a"
             pp_failures failures filename) );
      r)
