(* Recitation 5: Basic Calculator *)

(** Constant variant representing a binary operator. *)
type binop =
| Add
| Mul

(** Tries to convert a char into a binary operator.
  For example, [binop_of_char "+"] is [Some Add].
  @param c An arbitrary character
  @return [Some op] if [c] is a valid operator, otherwise [None].
 *)
let binop_of_char (c: char) : binop option = match c with
| '+' -> Some Add
| '*' -> Some Mul
| _   -> None

(** Converts a binary operator into its string representation. *)
let string_of_binop (o: binop) : string = match o with
| Add -> "+"
| Mul -> "*"

(** Tagged variant representing a numeric value. *)
type value =
| Inf
| Int of int

(** Tries to convert a char into a value.
  @param c An arbitrary character
  @return [Some value] if [c] is a valid number, otherwise [None].
 *)
let value_of_char (c: char) : value option = match c with
| '0'..'9' -> Some (Int (Char.code c - 48))
| 'i'      -> Some Inf
| _        -> None

(** Converts a value into its string representation. *)
let string_of_value (v: value) : string = match v with
| Inf   -> "i"
| Int i -> string_of_int i

(** Recursive variant that represents an arithmetic expression. *)
type exp =
| Value of value
| Binop of binop * exp * exp

(** Parse a string in the following format into an expression:
  
   exp ::= 0 - 9
         | i
         | exp+exp
         | exp*exp
  
   For example, "1+2*3+i" or "9*0+1" or "i*i".

   @param s An arbitrary string.
   @return [Some exp] if [s] is a valid expression, otherwise [None].
*)
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

(** Converts an expression into its string representation. *)
let rec string_of_exp (e: exp) : string = match e with
| Value v            -> string_of_value v
| Binop (op, e1, e2) -> (string_of_exp e1) ^ (string_of_binop op) ^ (string_of_exp e2)

(** Evaluates an expression to a value using the following rules:
  1) Infinity + anything is infinity
  2) Infinity * anything is infinity
  3) Everything is as you'd expect
 *)
let rec evaluate (exp: exp) : value = match exp with
| Value v -> v
| Binop (op, e1, e2) ->
  let v1 = evaluate e1 in
  let v2 = evaluate e2 in
  match (op, v1, v2) with
  | (Add, Int i1, Int i2) -> Int (i1 + i2)
  | (Mul, Int i1, Int i2) -> Int (i1 * i2)
  | _                     -> Inf

let expressions = [
  "i";
  "1";
  "1+2";
  "i*5";
  "1+2+3";
  "1*1*4";
]

let expected = [
  "i";
  "1";
  "3";
  "i";
  "6";
  "4";
]

let _ = List.iter2
  (fun input expected ->
    match exp_of_string input with
    | None -> ()
    | Some exp -> begin
      print_string (string_of_exp exp);
      print_string " evaluates to ";
      print_endline (exp |> evaluate |> string_of_value)
    end
  ) 
  expressions
  expected
