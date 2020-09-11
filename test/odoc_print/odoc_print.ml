(** Print .odocl files. *)

open Odoc_odoc
open Or_error

let pf = Format.fprintf

(* Printing *)

let print_page fmt page =
  pf fmt "%s\n" (Pp_lang.Page.show page)

(* CLI *)

let run inp =
  let inp = Fpath.v inp in
  Page.load inp >>= fun page ->
  print_page Format.std_formatter page;
  Ok ()

open Cmdliner

let a_inp =
  let doc = "Input file." in
  Arg.(required & pos 0 (some file) None & info ~doc ~docv:"PATH" [])

let term =
  let doc = "Print the content of .odoc files into a text format. For tests" in
  Term.(const run $ a_inp, info "odoc_print" ~doc)

let () =
  match Term.eval term with
  | `Ok (Ok ()) -> ()
  | `Ok (Error (`Msg msg)) ->
      Printf.eprintf "Error: %s\n" msg;
      exit 1
  | cmdliner_error -> Term.exit cmdliner_error
