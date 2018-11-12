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

let eval_exp (e: exp) : (value, error) result =
  failwith "unimplemented"

let eval_stm (s: stm) : (unit, error) result =
  failwith "unimplemented"

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.program Lexer.token lexbuf in
  let _ = eval_stm program in
  ()
