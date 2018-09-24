type ('k, 'v) t

val empty: ('k, 'v) t

val insert: ('k, 'v) t -> 'k -> 'v -> ('k, 'v) t

val get: ('k, 'v) t -> 'k -> 'v list

(* Extra challenge functions below! *)

val insert_all: ('k, 'v) t -> 'k -> 'v list -> ('k, 'v) t

val remove: ('k, 'v) t -> 'k -> 'v -> ('k, 'v) t

val remove_all: ('k, 'v) t -> 'k -> ('k, 'v) t
