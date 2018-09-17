(** Represents a positive integer. *)
module type Positive = sig

  type t

  val make: int -> t option

  val get: t -> int

end

(** Sealed implementation of Positive using int. *)
module IntegerPrivate : Positive = struct

  type t = int

  let make n =
    if n < 0 then None else Some n

  let get n = n

end

(** Implementation of Positive with sharing constraint. *)
module IntegerPublic : Positive with type t = int = struct

  type t = int

  let make n =
    if n < 0 then None else Some n

  let get n = n

end
