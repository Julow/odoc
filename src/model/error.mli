type t

val make :
  ?suggestion:string -> ('a, unit, string, Location_.span -> t) format4 -> 'a
val filename_only : string -> string -> t

val to_string : t -> string

type 'a with_warnings = {
  value : 'a;
  warnings : t list;
}

type 'a with_error_and_warnings = ('a with_warnings, t) Result.result

val raise_exception : t -> _
val raise_warning : t -> unit
val to_exception : ('a, t) Result.result -> 'a
val catch : (unit -> 'a) -> 'a with_error_and_warnings

(** To be called inside a [catch] *)
val raise_error_and_warnings : 'a with_error_and_warnings -> 'a
val raise_warnings : 'a with_warnings -> 'a

type warning_accumulator

val accumulate_warnings : (warning_accumulator -> 'a) -> 'a with_warnings
val warning : warning_accumulator -> t -> unit

(** In case of success with warnings, print them and return the wrapped value
    In case of error, raise a [Failure] exception *)
val shed_error_and_warnings : 'a with_error_and_warnings -> 'a

(** When set to [true],
   [shed_warnings] will raise [Failure] if it had to print warnings. *)
val set_warn_error : bool -> unit
