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
let read_source_file cmt_infos source_path =
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
      Some { Lang.Source_code.id; impl_source; impl_info }

type args = { html_config : Odoc_html.Config.t; source_file : string option }

let render { html_config; source_file } page =
  Odoc_html.Generator.render ~config:html_config page

let extra_documents args unit =
  match unit.source, args.source_file with
  | Some { Odoc_model.Lang.Source_info.id; infos }, Some src -> (
  match Fs.File.read source_path with
  | Error (`Msg msg) ->
      Error.raise_warning
        (Error.filename_only "Couldn't load source file: %s" msg
           (Fs.File.to_string source_path));
      []
  | Ok source_code ->
      let infos = infos @ Source_info.of_source source_code in
      [ Odoc_document.Renderer.document_of_source id infos source_code ]
    )
  | Some _, None -> [] (* TODO: source code not passed *)
  | None, Some _ -> [] (* TODO: compilation unit was not compiled with --source-parent and --source-name *)
  | None, None -> []

let renderer = { Odoc_document.Renderer.name = "html"; render; extra_documents }
