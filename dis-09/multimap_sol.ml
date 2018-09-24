type ('k, 'v) t = 'k -> 'v list

(** [empty] is an empty map.
    For all keys [k], [get empty k = []].
 *)
let empty =
  fun _ -> []

(** [insert map k v] is [map] extended with a new binding (k, v).
    Allows duplicate values.

    Examples: [insert {1: [1, 2]} 1 3] = [{1: [1, 2, 3]}]
              [insert {1: [1], 2: [2]} 3 3] = [{1: [1], 2: [2], 3: [3]}]
              [insert empty 1 2] = [{1: [2]}]
 *)
let insert map k v = 
  fun k' -> if k = k' then v :: map k' else map k'

(** [get map k] is the list of values bound to [k] in [map], in reverse order of insertion.

    Returns: empty list if [k] is not bound in [map].

    Examples: [get {1: [1]} 1] = [[1]]
              [get empty 1] = [[]]
              [get {2: [2, 3]} 2] = [[2, 3]]
 *)
let get map k =
  map k

(** [insert_all map k vs] is [map] extended by adding bindings [(k, v) for v in vs]
    in order. Equivalent to [List.fold_left (fun map v -> insert map k v) map vs].

    Examples: [insert_all empty 1 [1, 2, 3]] = [{1: [1, 2, 3]}]
 *)
let insert_all map k vs =
  fun k' -> if k = k' then (List.rev vs) @ map k' else map k'

(** [remove map k v] is [map] with all bindings (k, v) removed (including duplicates).
    Does nothing if [(k, v)] is not bound in [map].

    Examples: [remove empty 1 2] = [empty]
              [remove {1: [3, 4, 3]} 3 4] = [{1: [4]}]
 *)
let remove map k v =
  fun k' -> if k = k' then List.filter (fun v' -> v <> v') (map k') else map k'

(** [remove_all map k] is [map] with all bindings for k removed.
    Does nothing if [k] is not bound in [map].

    Examples: [remove_all empty 1] = [empty]
              [remove {1: [1, 2, 3, 4, 5], 2: [3]} 1] = [{2: [3]}]
 *)
let remove_all map k =
  fun k' -> if k = k' then [] else map k'
