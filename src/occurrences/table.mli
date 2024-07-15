type t
type sub
type item = { direct : int; indirect : int; sub : sub }
type key = Odoc_model.Paths.Identifier.t

val v : unit -> t

val add : ?quantity:int -> t -> key -> unit

val iter : (key -> item -> unit) -> t -> unit

val get : t -> key -> item option
