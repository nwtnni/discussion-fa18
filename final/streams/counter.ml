(* Represents an bi-directional infinite stream of ints *)
type counter =
| Counter of (int * thunk * thunk)

and thunk = unit -> counter

(** [make n] is a counter starting at value [n]. *)
let rec make (n: int) : counter =
  failwith "Unimplemented"

(** [up c] is [c] stepped up by one *)
let up (c: counter) : counter = 
  failwith "Unimplemented"

(** [down c] is [c] stepped down by one *)
let down (c: counter) : counter =
  failwith "Unimplemented"

(** [value c] is the current value of counter [c] *)
let value (c: counter) : int =
  failwith "Unimplemented"
