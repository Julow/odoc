type t

val make :
  ?suggestion:string -> ('a, Format.formatter, unit, Location_.span -> t) format4 -> 'a
val filename_only :
  ?suggestion:string -> ('a, Format.formatter, unit, string -> t) format4 -> 'a

val to_string : t -> string

val raise_exception : t -> _
val to_exception : ('a, t) Result.result -> 'a
val catch : (unit -> 'a) -> ('a, t) Result.result

type 'a with_warnings = {
  value : 'a;
  warnings : t list;
}

type warning_accumulator

val accumulate_warnings : (warning_accumulator -> 'a) -> 'a with_warnings
val warning : warning_accumulator -> t -> unit
val shed_warnings : 'a with_warnings -> 'a

val implicit_warning :
  ?suggestion:string -> ('a, Format.formatter, unit, unit) format4 -> 'a
(** Generates a warning that will be handled by the enclosing call to
    [with_implicit_accumulator]. *)

type loc = [ `With_loc of Location_.span | `Filename_only of string ]

val with_implicit_accumulator :
  loc -> (unit -> 'a) -> 'a with_warnings
(** Calls [f] and record calls to [implicit_warning]. *)

(** When set to [true],
   [shed_warnings] will raise [Failure] if it had to print warnings. *)
val set_warn_error : bool -> unit
