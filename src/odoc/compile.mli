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

open Or_error

type parent_cli_spec =
  | CliParent of string
  | CliPackage of string
  | CliNoparent

(** Produces .odoc files out of [.cm{i,t,ti}] or .mld files. *)

val compile :
  resolver:Resolver.t ->
  parent_cli_spec:parent_cli_spec ->
  hidden:bool ->
  children:string list ->
  output:Fs.File.t ->
  warnings_options:Odoc_model.Error.warnings_options ->
  source:(Fpath.t * string) option ->
  source_children:string list ->
  Fs.File.t ->
  (unit, [> msg ]) result
