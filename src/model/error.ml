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
]

let full message location =
  `With_full_location {location; message}

let filename_only message file =
  `With_filename_only {file; message}

let make ?suggestion format =
  format |>
  Printf.ksprintf (fun message ->
    match suggestion with
    | None -> full message
    | Some suggestion -> full (message ^ "\nSuggestion: " ^ suggestion))

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



type 'a with_warnings = {
  value : 'a;
  warnings : t list;
}

type 'a with_error_and_warnings = ('a with_warnings, t) Result.result



let warning_accumulator = ref []

exception Conveyed_by_exception of t

let raise_exception error =
  raise (Conveyed_by_exception error)

let raise_warning warn =
  warning_accumulator := warn :: !warning_accumulator

let to_exception = function
  | Ok v -> v
  | Error error -> raise_exception error

let catch f =
  let prev_accumulator = !warning_accumulator in
  warning_accumulator := [];
  let r =
    match f () with
    | exception Conveyed_by_exception error -> Error error
    | value ->
      let warnings = List.rev !warning_accumulator in
      Ok { value; warnings }
  in
  warning_accumulator := prev_accumulator;
  r

(** This function is only used in parser/reference.ml *)
let catch_error f =
  match f () with
  | exception Conveyed_by_exception error -> Error error
  | value -> Ok value

let raise_warnings { value; warnings } =
  warning_accumulator := List.rev_append warnings !warning_accumulator;
  value

let raise_error_and_warnings r =
  raise_warnings (to_exception r)



type warning_accumulator = t list ref

let accumulate_warnings f =
  let warnings = ref [] in
  let value = f warnings in
  {value; warnings = List.rev !warnings}

let warning accumulator error =
  accumulator := error::!accumulator

let print_warning e = prerr_endline (to_string e)

let shed_error_and_warnings ~warn_error = function
  | Ok { value; warnings = [] } -> value
  | Ok { value; warnings } ->
    List.iter print_warning warnings;
    if warn_error then
      failwith "Warnings have been generated."
    else
      value
  | Error e -> failwith (to_string e)
