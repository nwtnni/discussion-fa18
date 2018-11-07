open Ast
open Parser
open Lexer

(* Environment binding variable names to values *)
module EnvMut = struct
  type t = (string * int) list list ref

  let empty = ref [[]]

  let push (env: t): unit =
    env := [] :: !env

  let pop (env: t): unit =
    match !env with
    | []        -> failwith "[INTERNAL ERROR]: no environment"
    | _ :: []   -> failwith "[INTERNAL ERROR]: should not pop last namespace"
    | _ :: env' -> env := env'

  let insert (v: string) (n: int) (env: t): unit =
    match !env with
    | []        -> failwith "[INTERNAL ERROR]: no environment"
    | h :: t    -> env := ((v, n) :: h) :: t

  let rec find (v: string) (env: t): int =
    match !env with
    | []        -> failwith ("Unbound variable: " ^ v)
    | env' :: t ->
      match List.assoc_opt v env' with
      | None   -> find v (ref t)
      | Some n -> n
end

let rec eval_exp (env: EnvMut.t) (e: exp): int =
  match e with
  | Int n -> n
  | Var v -> EnvMut.find v env
  | Add (l, r) -> eval_exp env l + eval_exp env r

let rec eval_stm (env: EnvMut.t) (s: stm): unit =
  match s with
  | Assign (v, e) ->
    let n = eval_exp env e in
    EnvMut.insert v n env
  | Seq (s1, s2) ->
    eval_stm env s1;
    eval_stm env s2
  | Print e ->
    print_int (eval_exp env e);
    print_newline ()
  | Scope s ->
    EnvMut.push env;
    eval_stm env s;
    EnvMut.pop env

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.prog Lexer.token lexbuf in
  let env = EnvMut.empty in
  let _ = eval_stm env program in
  ()
