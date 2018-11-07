open Ast
open Parser
open Lexer

(* Environment binding variable names to values *)
module Env = struct
  type t = (string * int) list

  let empty = []

  let insert (v: string) (n: int) (env: t): t =
    (v, n) :: env

  let rec find (v: string) (env: t): int =
    match List.assoc_opt v env with
    | None   -> failwith ("Unbound variable " ^ v)
    | Some n -> n
end

let rec eval_exp (env: Env.t) (e: exp): int =
  match e with
  | Int n -> n
  | Var v -> Env.find v env
  | Add (l, r) -> eval_exp env l + eval_exp env r

let rec eval_stm (env: Env.t) (s: stm): Env.t =
  match s with
  | Assign (v, e) ->
    let n = eval_exp env e in
    let env' = Env.insert v n env in
    env'
  | Seq (s1, s2) ->
    let env' = eval_stm env s1 in
    let env'' = eval_stm env' s2 in
    env''
  | Print e ->
    print_int (eval_exp env e);
    print_newline ();
    env
  | Scope s ->
    let _ = eval_stm env s in
    env (* Ignore all bindings from inside scope *)

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.prog Lexer.token lexbuf in
  let env = Env.empty in
  let _ = eval_stm env program in
  ()
