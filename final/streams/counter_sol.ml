(* Represents an bi-directional infinite stream of ints *)
type counter =
| Counter of (int * thunk * thunk)

and thunk = unit -> counter

(** [make n] is a counter starting at value [n]. *)
let rec make (n: int) : counter =
  let up = fun () -> make (n + 1) in
  let down = fun () -> make (n - 1) in
  Counter (n, up, down)

(** [up c] is [c] stepped up by one *)
let up: (counter -> counter) = function
| Counter (_, up, _) -> up ()

(** [down c] is [c] stepped down by one *)
let down: (counter -> counter) = function
| Counter (_, _, down) -> down ()

(** [value c] is the current value of counter [c] *)
let value: (counter -> int) = function
| Counter (n, _, _) -> n
