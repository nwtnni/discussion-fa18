open Ast

type ('ok, 'err) result =
| Val of 'ok
| Exn of 'err

let (>>=) result f = match result with
| Val v -> f v
| Exn e -> Exn e

type ok =
| Unit
| Bool of bool
| Int of int

type err =
| ExpectedInt
| ExpectedBool

let eval_exp (e: exp) : (ok, err) result =
  failwith "unimplemented"

let eval_stm (s: stm) : (ok, err) result =
  failwith "unimplemented"

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.program Lexer.token lexbuf in
  let _ = eval_stm program in
  ()
