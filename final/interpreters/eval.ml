open Parser
open Lexer
open Ast

type env = (string * int) list

(** Evaluate arithmetic expression [a] in environment [env] *)
let rec eval_aexp (env: env) (a: aexp): int =
  failwith "Unimplemented"

(** Evaluate boolean expression [b] in environment [env] *)
and eval_bexp (env: env) (b: bexp) : bool =
  failwith "Unimplemented"

(** Evaluate command [c] in environment [env] *)
and eval_comm (env: env) (c: comm) : env =
  failwith "Unimplemented"

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.program Lexer.token lexbuf in
  eval_comm [] program |> ignore
