(** Represents a type with a zero value. *)
module type Zero = sig

  (** Abstract type. *)
  type t

  (** Zero value. *)
  val zero : t

  (** True if the passed in value is equal to zero. *)
  val is_zero : t -> bool

end

(** Module without explicit signature. *)
module Free = struct

  type t = int

  let zero = 0

  let is_zero = (=) 0

end

(** Module with explicit signature. *)
module Constrained : Zero = struct

  type t = int

  let zero = 0

  let is_zero = (=) 0

end

(** Module with explicit signature and sharing constraints. *)
module Shared : (Zero with type t = int) = struct

  type t = int

  let zero = 0

  let is_zero = (=) 0

end

(** Retroactively constrained module. *)
module FreeConstrained : Zero = Free

(** Retroactively constrained module with explict sharing. *)
module FreeShared : (Zero with type t = int) = Free
