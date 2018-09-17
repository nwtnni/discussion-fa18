(* A signature that only exposes a single trivial value. *)
module type Seal = sig

  type t

  val trivial: t

end

(** An implementation of the Seal signature that is free
 *  to share the meaning of life.
 *)
module Constant = struct

  type t = int

  let trivial = 0

  let meaning_of_life = 42

end

(** An implementation of the Seal signature that is
    explicitly sealed by the interface, and cannot
    share the meaning of life.
 *)
module ConstantConstrained : Seal = struct

  type t = int

  let trivial = 0

  let meaning_of_life = 42

end
