open Parser
open Lexer
open Ast

type env = (string * int) list

(** Evaluate arithmetic expression [a] in environment [env] *)
let rec eval_aexp (env: env) (a: aexp): int =
  match a with
  | Input -> read_line () |> int_of_string
  | Int n -> n
  | Var v -> List.assoc v env
  | Add (l, r) -> eval_aexp env l + eval_aexp env r
  | Sub (l, r) -> eval_aexp env l - eval_aexp env r

(** Evaluate boolean expression [b] in environment [env] *)
and eval_bexp (env: env) (b: bexp) : bool =
  match b with
  | True -> true
  | False -> false
  | Eq (l, r) -> eval_aexp env l = eval_aexp env r
  | Ne (l, r) -> eval_aexp env l <> eval_aexp env r

(** Evaluate command [c] in environment [env] *)
and eval_comm (env: env) (c: comm) : env =
  match c with
  | Skip -> env
  | Assign (v, a) ->
    let n = eval_aexp env a in
    (v, n) :: env
  | Print a ->
    Format.printf "%i\n" (eval_aexp env a);
    Format.print_flush ();
    env
  | Seq (c, c') ->
    let env' = eval_comm env c in
    eval_comm env' c'
  | If (b, c, c') ->
    if eval_bexp env b then
      eval_comm env c
    else
      eval_comm env c'
  | While (b, c) ->
    if not (eval_bexp env b) then
      env 
    else
      let env' = eval_comm env c in
      eval_comm env' (While (b, c))

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.program Lexer.token lexbuf in
  eval_comm [] program |> ignore
