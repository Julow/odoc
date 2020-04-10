open Odoc_model
open Lang

val link : Env.resolver -> Compilation_unit.t -> Compilation_unit.t

val resolve_page : Env.resolver -> Page.t -> Page.t
