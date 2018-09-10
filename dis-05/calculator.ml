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
| _ -> failwith "unimplemented"

(** Converts a binary operator into its string representation. *)
let string_of_binop (o: binop) : string = match o with
| _ -> failwith "unimplemented"

(** Tagged variant representing a numeric value. *)
type value =
| Inf
| Int of int

(** Tries to convert a char into a value.
  @param c An arbitrary character
  @return [Some value] if [c] is a valid number, otherwise [None].
 *)
let value_of_char (c: char) : value option = match c with
| _ -> failwith "unimplemented"

(** Converts a value into its string representation. *)
let string_of_value (v: value) : string = match v with
| _ -> failwith "unimplemented"

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
let exp_of_string (s: string) : exp option =
  failwith "unimplemented"

(** Converts an expression into its string representation. *)
let string_of_exp (e: exp) : string = match e with
| _ -> failwith "unimplemented"

(** Evaluates an expression to a value using the following rules:
  1) Infinity + anything is infinity
  2) Infinifty * anything is infinity
  3) Everything is as you'd expect
 *)
let evaluate (exp: exp) : value = match exp with
| _ -> failwith "unimplemented"

let expressions = [
  Value Inf;
  Value (Int 1);
  Binop (Add, Value (Int 1), Value (Int 2));
  Binop (Mul, Value Inf, Value (Int 2));
  Binop (Add, Value (Int 1), Binop (Add, Value (Int 2), Value (Int 3)));
]

let expected = [
  "i";
  "1";
  "3";
  "i";
  "6";
]
