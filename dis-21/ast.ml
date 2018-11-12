(** Represents a binary operation *)
type binop =
| Add
| And
| Or

(** Represents expressions that evaluate to a value *)
type exp =
| True
| False
| Int of int
| Bin of (binop * exp * exp)

(** Represents statements that don't evaluate to a value *)
type stm =
| If of (exp * stm * stm)
| Seq of (stm * stm)
| Print of exp
