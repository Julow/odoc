open Result



type full_location_payload = {
  location : Location_.span;
  message : string;
}

type filename_only_payload = {
  file : string;
  message : string;
}

type t = [
  | `With_full_location of full_location_payload
  | `With_filename_only of filename_only_payload
  | `Without_location of string
]

let kasprintf k fmt =
  Format.(kfprintf (fun _ -> k (flush_str_formatter ())) str_formatter fmt)

let kmake k ?suggestion format =
  format |>
  kasprintf (fun message ->
    match suggestion with
    | None -> k message
    | Some suggestion -> k (message ^ "\nSuggestion: " ^ suggestion))

let make ?suggestion format =
  let k message location = `With_full_location {location; message} in
  kmake k ?suggestion format

let filename_only ?suggestion format =
  let k message file = `With_filename_only {file; message} in
  kmake k ?suggestion format

(** Only used internally *)
let without_location message =
  `Without_location message

let to_string = function
  | `With_full_location {location; message} ->
    let location_string =
      if location.start.line = location.end_.line then
        Printf.sprintf "line %i, characters %i-%i"
          location.start.line
          location.start.column
          location.end_.column
      else
        Printf.sprintf "line %i, character %i to line %i, character %i"
          location.start.line
          location.start.column
          location.end_.line
          location.end_.column
    in
    Printf.sprintf "File \"%s\", %s:\n%s" location.file location_string message

  | `With_filename_only {file; message} ->
    Printf.sprintf "File \"%s\":\n%s" file message

  | `Without_location message ->
    message



exception Conveyed_by_exception of t

let raise_exception error =
  raise (Conveyed_by_exception error)

let to_exception = function
  | Ok v -> v
  | Error error -> raise_exception error

let catch f =
  try Ok (f ())
  with Conveyed_by_exception error -> Error error



type 'a with_warnings = {
  value : 'a;
  warnings : t list;
}

type warning_accumulator = t list ref

let accumulate_warnings f =
  let warnings = ref [] in
  let value = f warnings in
  {value; warnings = List.rev !warnings}

let warning accumulator error =
  accumulator := error::!accumulator

let warn_error = ref false

(* TODO This is a temporary measure until odoc is ported to handle warnings
   throughout. *)
let shed_warnings with_warnings =
  with_warnings.warnings
  |> List.iter (fun warning -> warning |> to_string |> prerr_endline);
  if !warn_error && with_warnings.warnings <> [] then
    raise_exception (without_location "Warnings have been generated.");
  with_warnings.value

let set_warn_error b = warn_error := b

let implicit_acc = ref []

let implicit_warning ?suggestion format =
  let k message = implicit_acc := message :: !implicit_acc in
  kmake k ?suggestion format

type loc = [ `With_loc of Location_.span | `Filename_only of string ]

let with_implicit_accumulator location f =
  let make_warning =
    match location with
    | `With_loc location ->
        fun message -> `With_full_location { location; message }
    | `Filename_only file ->
        fun message -> `With_filename_only { file; message }
  in
  let prev_acc = !implicit_acc in
  implicit_acc := [];
  let value = f () in
  let warnings = List.rev_map make_warning !implicit_acc in
  implicit_acc := prev_acc;
  { value; warnings }
