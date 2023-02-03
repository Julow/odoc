(*
 * Copyright (c) 2014 Leo White <leo@lpw25.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(** Raises errors. *)
let read_source_file ~root cmt_infos source_path =
  let source_name = Fpath.filename source_path in
  match Fs.File.read source_path with
  | Error (`Msg msg) ->
      Error.raise_warning
        (Error.filename_only "Couldn't load source file: %s" msg
           (Fs.File.to_string source_path));
      None
  | Ok impl_source ->
      let impl_info =
        match cmt_infos with
        | Some (_, local_jmp) ->
            Odoc_loader.Source_info.of_source ~local_jmp impl_source
        | _ -> []
      in
      let id = Paths.Identifier.Mk.source_page (root, source_name) in
      Some { Lang.Source_code.id; impl_source; impl_info }

  let sources =
    match source_code with
    | None -> None
    | Some (source_path, source_parent) ->
        read_source_file ~root:source_parent cmt_infos source_path
  in

type args = { html_config : Odoc_html.Config.t; source_file : string option }

let render { html_config; source_file } page =
  (* Load file
     Load source info of_source *)
  Odoc_html.Generator.render ~config page

let renderer = { Odoc_document.Renderer.name = "html"; render }
