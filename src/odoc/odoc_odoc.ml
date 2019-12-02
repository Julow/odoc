module Html_page = Html_page
module Html_fragment = Html_fragment
module Compile = Compile
module Support_files = Support_files
module Depends = Depends
module Targets = Targets

module Fs = Fs

(** Expose only a limited interface *)
module Env : sig
  type builder = Env.builder
  val create : ?important_digests:bool -> directories:(Fs.Directory.t list) -> builder
end = Env
