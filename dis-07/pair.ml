(** Represents a pair data structure.
    Both elements must be the same type.
 *)
module type Pair = sig

  (** Abstract type *)
  type 'a t

  (** Construct a pair *)
  val from: 'a -> 'a -> 'a t

  (** Take the first element of a pair *)
  val fst: 'a t -> 'a

  (** Take the second element of a pair *)
  val snd: 'a t -> 'a

end

(** Implements the Pair signature using tuples. *)
module TuplePair : Pair = struct

  type 'a t = ('a * 'a)

  let from a b =
    failwith "Unimplemented"

  let fst pair =
    failwith "Unimplemented"

  let snd pair =
    failwith "Unimplemented"

end

(** Implements the Pair signature using functions. *)
module FunctionPair : Pair = struct
  
  type 'a t = bool -> 'a

  let from a b =
    failwith "Unimplemented"

  let fst pair =
    failwith "Unimplemented"

  let snd pair =
    failwith "Unimplemented"

end
