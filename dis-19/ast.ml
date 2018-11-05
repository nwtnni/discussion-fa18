(** Represents an expression, which does evaluate to a value *)
type exp =
| Int of int
| Var of string
| Add of exp * exp

(** Represents a statement, which don't evaluate to a value *)
type stm =
| Assign of string * exp
| Seq of stm * stm
| Print of exp
| Scope of stm
