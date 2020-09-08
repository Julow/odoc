type 'a t = (string * 'a) list

let get = List.assoc_opt
let set k v t = (k, v) :: List.remove_assoc k t
