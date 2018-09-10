(* Recitation 5: Basic Calculator Solution *)

type binop =
| Add
| Mul

type value =
| Inf
| Int of int

type exp =
| Value of value
| Binop of binop * exp * exp

let binop_of_char (c: char) : binop option = match c with
| '+' -> Some Add
| '*' -> Some Mul
| _   -> None

let string_of_binop (o: binop) : string = match o with
| Add -> "+"
| Mul -> "*"

let value_of_char (c: char) : value option = match c with
| '0'..'9' -> Some (Int (Char.code c - 48))
| 'i'      -> Some Inf
| _        -> None

let string_of_value (v: value) : string = match v with
| Inf   -> "i"
| Int i -> string_of_int i

let rec exp_of_string (s: string) : exp option = match String.length s with
| 0 -> None
| 1 ->
    begin match value_of_char s.[0] with
    | Some v -> Some (Value v)
    | None   -> None
    end
| l when l > 2 ->
    let e1 = value_of_char s.[0] in
    let op = binop_of_char s.[1] in
    let e2 = exp_of_string (String.sub s 2 (l - 2)) in
    begin match (e1, op, e2) with
    | (Some e1, Some op, Some e2) -> Some (Binop (op, Value e1, e2))
    | _                           -> None
    end
| _ -> None

let rec string_of_exp (e: exp) : string = match e with
| Value v            -> string_of_value v
| Binop (op, e1, e2) -> (string_of_exp e1) ^ (string_of_binop op) ^ (string_of_exp e2)

let rec evaluate (exp: exp) : value = match exp with
| Value v -> v
| Binop (op, e1, e2) ->
  let v1 = evaluate e1 in
  let v2 = evaluate e2 in
  match (op, v1, v2) with
  | (Add, Int i1, Int i2) -> Int (i1 + i2)
  | (Mul, Int i1, Int i2) -> Int (i1 * i2)
  | _                     -> Inf

let rec count_infinity (exp: exp) : int = match exp with
| Value Inf     -> 1
| Value (Int _) -> 0
| Binop (_, e1, e2) -> (count_infinity e1) + (count_infinity e2)

let rec add_one (exp: exp) : exp = match exp with
| Value Inf          -> Value Inf
| Value (Int i)      -> Value (Int (i + 1))
| Binop (op, e1, e2) -> Binop (op, add_one e1, add_one e2)
