(** Re-export [result] for compatibility. This module is meant to be opened. *)
module ResultMonad = struct
  type ('a, 'b) result = ('a, 'b) Result.result = Ok of 'a | Error of 'b

  let return x = Ok x

  let map_error f = function Ok _ as ok -> ok | Error e -> Error (f e)

  let ( >>= ) m f = match m with Ok x -> f x | Error _ as e -> e
end

(* This module is meant to be opened. *)
module OptionMonad = struct
  let return x = Some x

  (* The error case become [None], the error value is ignored. *)
  let of_result = function Result.Ok x -> Some x | Error _ -> None

  let ( >>= ) m f = match m with Some x -> f x | None -> None
end
