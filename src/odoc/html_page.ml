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

open StdLabels

let to_html_tree_page ?theme_uri ~syntax v =
  match syntax with
  | Odoc_html.Tree.Reason -> Odoc_html.Generator.Reason.page ?theme_uri v
  | Odoc_html.Tree.OCaml -> Odoc_html.Generator.ML.page ?theme_uri v

let to_html_tree_compilation_unit ?theme_uri ~syntax v =
  match syntax with
  | Odoc_html.Tree.Reason -> Odoc_html.Generator.Reason.compilation_unit ?theme_uri v
  | Odoc_html.Tree.OCaml -> Odoc_html.Generator.ML.compilation_unit ?theme_uri v

let from_odoc ~env ?(syntax=Odoc_html.Tree.OCaml) ?theme_uri ~output:root_dir input =
  let root = Root.read input in
  match root.file with
  | Page page_name ->
    let page = Page.load input in
    let odoctree =
      let resolve_env = Env.build env (`Page page) in
      Odoc_xref2.Link.resolve_page resolve_env page
    in
    let pkg_name = root.package in
    let pages = to_html_tree_page ?theme_uri ~syntax odoctree in
    let pkg_dir = Fs.Directory.reach_from ~dir:root_dir pkg_name in
    Fs.Directory.mkdir_p pkg_dir;
    Odoc_html.Tree.traverse pages ~f:(fun ~parents _pkg_name content ->
      assert (parents = []);
      let oc =
        let f = Fs.File.create ~directory:pkg_dir ~name:(page_name ^ ".html") in
        open_out (Fs.File.to_string f)
      in
      let fmt = Format.formatter_of_out_channel oc in
      Format.fprintf fmt "%a@?" (Tyxml.Html.pp ()) content;
      close_out oc
    );
    (* Printf.fprintf stderr "num_times: %d\n%!" !Odoc_xref2.Tools.num_times *)
  | Compilation_unit {hidden = true; _} ->
    ()
  | Compilation_unit {hidden = _; _} ->
    (* If hidden, we should not generate HTML. See
         https://github.com/ocaml/odoc/issues/99. *)
    let unit = Compilation_unit.load input in
(*    let unit = Odoc_xref.Lookup.lookup unit in *)
    let odoctree =
      let env = Env.build env (`Unit unit) in
      (* let startlink = Unix.gettimeofday () in *)
      (* Format.fprintf Format.err_formatter "**** Link...\n%!"; *)
      let linked = Odoc_xref2.Link.link env unit in
      (* let finishlink = Unix.gettimeofday () in *)
      (* Format.fprintf Format.err_formatter "**** Finished: Link=%f\n%!" (finishlink -. startlink); *)
      (* Printf.fprintf stderr "num_times: %d\n%!" !Odoc_xref2.Tools.num_times; *)
      linked
    in
    (* let stats = Odoc_xref2.Tools.(Memos1.stats memo) in
    Format.fprintf Format.err_formatter "Hashtbl memo1: n=%d nb=%d maxb=%d\n%!" stats.num_bindings stats.num_buckets stats.max_bucket_length; *)
    let stats = Odoc_xref2.Tools.(Memos2.stats module_resolve_cache) in
    Format.fprintf Format.err_formatter "Hashtbl memo2: n=%d nb=%d maxb=%d\n%!" stats.num_bindings stats.num_buckets stats.max_bucket_length;
    Format.fprintf Format.err_formatter "time wasted: %f\n%!" (!Odoc_xref2.Tools.time_wasted);
    let pkg_dir =
      Fs.Directory.reach_from ~dir:root_dir root.package
    in
    let pages = to_html_tree_compilation_unit ?theme_uri ~syntax odoctree in
    Odoc_html.Tree.traverse pages ~f:(fun ~parents name content ->
      let directory =
        let dir =
          List.fold_right ~f:(fun name dir -> Fs.Directory.reach_from ~dir name)
            parents ~init:pkg_dir
        in
        Fs.Directory.reach_from ~dir name
      in
      let oc =
        Fs.Directory.mkdir_p directory;
        let file = Fs.File.create ~directory ~name:"index.html" in
        open_out (Fs.File.to_string file)
      in
      let fmt = Format.formatter_of_out_channel oc in
      Format.fprintf fmt "%a@?" (Tyxml.Html.pp ()) content;
      close_out oc
    );
    Compilation_unit.save (Fs.File.set_ext "odocl" input) odoctree


(* Used only for [--index-for] which is deprecated and available only for
   backward compatibility. It should be removed whenever. *)
let from_mld ~env ?(syntax=Odoc_html.Tree.OCaml) ~package ~output:root_dir input =
  let root_name = "index" in
  let digest = Digest.file (Fs.File.to_string input) in
  let root =
    let file = Odoc_model.Root.Odoc_file.create_page root_name in
    {Odoc_model.Root.package; file; digest}
  in
  let name = `Page (root, Odoc_model.Names.PageName.of_string root_name) in
  let location =
    let pos =
      Lexing.{
        pos_fname = Fs.File.to_string input;
        pos_lnum = 0;
        pos_cnum = 0;
        pos_bol = 0
      }
    in
    Location.{ loc_start = pos; loc_end = pos; loc_ghost = true }
  in
  match Fs.File.read input with
  | Error (`Msg s) ->
    Printf.eprintf "ERROR: %s\n%!" s;
    exit 1
  | Ok str ->
    let content =
      match Odoc_loader.read_string name location str with
      | Error e -> failwith (Odoc_model.Error.to_string e)
      | Ok (`Docs content) -> content
      | Ok `Stop -> [] (* TODO: Error? *)
    in
    (* This is a mess. *)
    let page = Odoc_model.Lang.Page.{ name; content; digest } in
(*    let page = Odoc_xref.Lookup.lookup_page page in*)
    let env = Env.build env (`Page page) in
    let resolved = Odoc_xref2.Link.resolve_page env page in
    let pages = to_html_tree_page ~syntax resolved in
    let pkg_dir = Fs.Directory.reach_from ~dir:root_dir root.package in
    Fs.Directory.mkdir_p pkg_dir;
    Odoc_html.Tree.traverse pages ~f:(fun ~parents _pkg_name content ->
      assert (parents = []);
      let oc =
        let f = Fs.File.create ~directory:pkg_dir ~name:"index.html" in
        open_out (Fs.File.to_string f)
      in
      let fmt = Format.formatter_of_out_channel oc in
      Format.fprintf fmt "%a@?" (Tyxml.Html.pp ()) content;
      close_out oc
    )
