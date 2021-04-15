(** Main module of this test. *)

module X = Test_x

module X_m = Test_x.M
module X_n = Test_x.N

(** An other example that is not an unit for comparison.
    @canonical Test.Y *)
module Test_y = struct
  type t
end

module Y = Test_y

(** An example with the tag inside the sig. *)
module Test_z = struct
  (** @canonical Test.Z *)

  type t
end

module W = Test_w
module W_m = Test_w.M
module W_n = Test_w.N

module Z = Test_z

type t = Test_x.t
type u = Test_y.t
type v = Test_z.t
