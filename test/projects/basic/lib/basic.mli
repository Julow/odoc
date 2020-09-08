(** A basic library. *)

(** [t] *)
type 'a t

(** [get] *)
val get : string -> 'a t -> 'a option

(** [set] *)
val set : string -> 'a -> 'a t -> 'a t
