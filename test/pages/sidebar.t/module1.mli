(** Foo *)

(** Heading 1 *)

module Foo : sig
  (** Heading Foo.1 *)
end

(** Heading 2 *)

module Bar : sig
  module Baz : sig
    (** Heading Bar.Baz.1 *)
  end

  (** Heading Bar.1 *)
end
