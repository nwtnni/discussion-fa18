open Ast

type ('ok, 'err) result =
| Ok of 'ok
| Err of 'err

let (>>=) result f = match result with
| Ok v -> f v
| Err e -> Err e

type value =
| Bool of bool
| Int of int

type error =
| ExpectedInt
| ExpectedBool

let extract_int (v: value) : (int, error) result =
  match v with
  | Int n -> Ok n
  | _     -> Err ExpectedInt

let extract_bool (v: value) : (bool, error) result =
  match v with
  | Bool b -> Ok b
  | _      -> Err ExpectedBool

let rec eval_exp (e: exp) : (value, error) result =
  match e with
  | True -> Ok (Bool true)
  | False -> Ok (Bool false)
  | Int n -> Ok (Int n)
  | Bin (Add, l, r) ->
    eval_exp l >>= extract_int >>= fun l ->
    eval_exp r >>= extract_int >>= fun r ->
    Ok (Int (l + r))
  | Bin (op, l, r) ->
    let f = if op = And then (&&) else (||) in
    eval_exp l >>= extract_bool >>= fun l ->
    eval_exp r >>= extract_bool >>= fun r ->
    Ok (Bool (f l r))

let rec eval_stm (s: stm) : (unit, error) result =
  match s with
  | If (b, s1, s2) ->
    eval_exp b >>= extract_bool >>= fun b ->
    if b then eval_stm s1 else eval_stm s2 
  | Seq (s1, s2) ->
    eval_stm s1 >>= fun () -> eval_stm s2
  | Print e ->
    eval_exp e >>= function
    | Int n -> print_int n; print_newline (); Ok ()
    | Bool true -> print_endline "true"; Ok ()
    | Bool false -> print_endline "false"; Ok ()

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.program Lexer.token lexbuf in
  match eval_stm program with
  | Ok ()            -> ()
  | Err ExpectedInt  -> print_endline "Error: expected int"
  | Err ExpectedBool -> print_endline "Error: expected bool"
