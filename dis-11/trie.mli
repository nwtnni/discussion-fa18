(** Abstract type representing a string set. *) 
type t

(** Empty set. *)
val empty : t

(** Converts a set into an unordered string list. *)
val to_list : t -> string list

(** [insert s set] is the set [set] after inserting string [s]. *)
val insert : string -> t -> t

(** [contains s set] is true iff [s] is in [set]. *)
val contains : string -> t -> bool

(** [remove s set] is the set [set] after removing string [s].
    Does nothing if [s] is not in the set.
*)
val remove : string -> t -> t
