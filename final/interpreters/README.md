# Imp

This is a basic interpreter for a simplified `Imp` programming language.

## TODO

Here's the AST you'll be evaluating:

```ocaml
(* Arithmetic expressions *)
type aexp =
| Input
| Int of int
| Var of string
| Add of aexp * aexp
| Sub of aexp * aexp

(* Boolean expressions *)
type bexp =
| True
| False
| Eq of aexp * aexp
| Ne of aexp * aexp

(* Commands *)
type comm =
| Skip
| Assign of string * aexp
| Print of aexp
| Seq of comm * comm
| If of bexp * comm * comm
| While of bexp * comm
```

You'll be implementing the following functions in `eval.ml`:

```ocaml
(** Evaluate arithmetic expression [a] in environment [env] *)
let rec eval_aexp (env: env) (a: aexp): int =
  failwith "Unimplemented"

(** Evaluate boolean expression [b] in environment [env] *)
and eval_bexp (env: env) (b: bexp) : bool =
	failwith "Unimplemented"

(** Evaluate command [c] in environment [env] *)
and eval_comm (env: env) (c: comm) : env =
	failwith "Unimplemented"
```

## Usage

You can build your interpreter with `make build`, and the reference solution with
`make sol`.

You can run your interpreter on test files by calling the binary with the name
of the file; for example:

```
./eval.byte test/while.imp
```
