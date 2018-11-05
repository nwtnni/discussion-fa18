open Ast
open Parser
open Lexer

(* Environment binding variable names to values *)
module Env = struct
  type t = (string * int) list list

  let empty = [[]]

  let push env = [] :: env

  let pop = function
  | []        -> failwith "[INTERNAL ERROR]: no environment"
  | _ :: []   -> failwith "[INTERNAL ERROR]: should not pop last namespace"
  | _ :: env' -> env'

  let insert (v: string) (n: int) = function
  | []     -> failwith "[INTERNAL ERROR]: no environment"
  | h :: t -> ((v, n) :: h) :: t

  (* TODO *)
  let rec find (v: string) (env: t) =
    failwith "Unimplemented"
end

let rec eval_exp (env: Env.t) (e: exp) : int =
  failwith "Unimplemented"

let rec eval_stm (env: Env.t) (s: stm): unit =
  failwith "Unimplemented"

let () =
  let file = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel file in
  let program = Parser.prog Lexer.token lexbuf in
  let env = Env.empty in
  eval_stm env program
