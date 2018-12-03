(* Arithmetic expressions *)
type aexp =
| Input
| Int of int
| Var of string
| Add of aexp * aexp
| Sub of aexp * aexp

(* Boolean expressions *)
type bexp =
| True
| False
| Eq of aexp * aexp
| Ne of aexp * aexp

(* Commands *)
type comm =
| Skip
| Assign of string * aexp
| Print of aexp
| Seq of comm * comm
| If of bexp * comm * comm
| While of bexp * comm
