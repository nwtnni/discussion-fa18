(** Represents an infinite OCaml expression of type [int] *)
type program =
| If  of bool * thunk * thunk
| Add of thunk * thunk
| Sub of thunk * thunk

and thunk = unit -> program

(** [make if_prob add_prob sub_prob] is an infinite program with
 * respective probabilities of generating [If], [Add], or [Sub] nodes.
 *
 * requires: [if_prob + add_prob + sub_prob = 100]
 *)
let rec make (if_prob: int) (add_prob: int) (sub_prob: int) : program =
  assert (if_prob + add_prob + sub_prob = 100);
  let make' () = make if_prob add_prob sub_prob in
  match Random.int 100 with
  | n when n < if_prob -> If (Random.bool (), make', make')
  | n when n < if_prob + add_prob -> Add (make', make')
  | _ -> Sub (make', make')

(** Represents a finite OCaml expression of type [int] *)
type finite =
| FInt of int
| FIf of bool * finite * finite
| FAdd of finite * finite
| FSub of finite * finite

(** Expand program [p] up to depth [depth] *)
let rec take (depth: int) (p: program) : finite =
  if depth = 0 then FInt (Random.int 100) else
  let depth' = depth - 1 in
  match p with
  | If (b, l, r) -> FIf (b, take depth' (l ()), take depth' (r ())) 
  | Add (l, r) -> FAdd (take depth' (l ()), take depth' (r ()))
  | Sub (l, r) -> FSub (take depth' (l ()), take depth' (r ()))

(** String representation of finite program [p] *)
let rec string_of_finite (p: finite) = 
  match p with
  | FInt n ->
    string_of_int n
  | FIf (true, l, r) ->
    Format.sprintf 
      "if true then %s else %s"
      (string_of_finite l)
      (string_of_finite r)
  | FIf (false, l, r) ->
    Format.sprintf 
      "if false then %s else %s"
      (string_of_finite l)
      (string_of_finite r)
  | FAdd (l, r) ->
    Format.sprintf 
      "(%s + %s)"
      (string_of_finite l)
      (string_of_finite r)
  | FSub (l, r) ->
    Format.sprintf 
      "(%s - %s)"
      (string_of_finite l)
      (string_of_finite r)

let () =
  try
    let if_prob = int_of_string Sys.argv.(1) in
    let add_prob = int_of_string Sys.argv.(2) in
    let sub_prob = int_of_string Sys.argv.(3) in
    let depth = int_of_string Sys.argv.(4) in
    make if_prob add_prob sub_prob
    |> take depth
    |> string_of_finite
    |> print_endline
  with
  _ -> Format.printf
    "%s\n%s\n"
    "Usage: ./program_sol.byte <IF_PROB> <ADD_PROB> <SUB_PROB> <DEPTH>"
    "\tWhere [IF_PROB + ADD_PROB + SUB_PROB = 100]"
