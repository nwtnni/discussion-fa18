# Solution

First of all, I made a mistake: `Env.t` does not have to be
a `(string * int) list list`; just a `(string * int) list` is
good enough in a functional language like OCaml. You do need
a `(string * int) list list` if your environment data structure
is mutable instead of immutable (for example, if you're working in a language
like Java or Rust), and I've included both immutable and mutable solutions
in `eval_sol.ml` and `eval_sol_mut.ml`, respectively.

We're almost entirely concerned with immutable data structures in this
course, so it's definitely the version you should focus on.
But if you have time, you can try to reason about the mutable version as well.

You can compile and run either solution with:

```
$ make sol
$ ./sol.byte test/<FILE>
```

```
$ make sol_mut
$ ./sol_mut.byte test/<FILE>
```

Both are correct as far as I know; let me know if you spot any bugs!

## Immutable 

The `Env` module I gave you can be simplified quite a bit assuming
immutability:

```ocaml
(* eval_sol.ml *)

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
```

How do we use this environment? Evaluating expressions is straightforward:

```ocaml
let rec eval_exp (env: Env.t) (e: exp): int =
  match e with
  | Int n -> n                     
  | Var v -> Env.find v env
  | Add (l, r) -> eval_exp env l + eval_exp env r
```

Evaluating statements is more interesting:

```ocaml
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
```

`eval_stm` has to return an updated environment in case we have an `Assign`.

Let's break down each case:

```ocaml
  | Assign (v, e) ->
    let n = eval_exp env e in
    let env' = Env.insert v n env in
    env'
```

Here we evaluate `e` to an integer `n` using `eval_exp`, and
then add a new binding `(v, n)` to our original environment `env`.
Finally, we return the updated environment `env'`.

```ocaml
  | Seq (s1, s2) ->
    let env' = eval_stm env s1 in
    let env'' = eval_stm env' s2 in
    env''
```

Here we evaluate statements `s1` and `s2` in sequence, making sure to
chain updated environments along.

```ocaml
  | Print e ->
    print_int (eval_exp env e);
    print_newline ();
    env
```

Here we evaluate `e` to an integer using `eval_exp`, print it out,
and then return our original environment.

```ocaml
  | Scope s ->
    let _ = eval_stm env s in
    env (* Ignore all bindings from inside scope *)
```

Here's the major difference between the immutable and mutable versions,
and why we only need a `list` instead of a `list list`: we know `env`
is immutable, so calling `eval_stm env s` doesn't change the value of
`env`. In order to simulate scoping, we can discard the new bindings
that come from inside statement `s` and return our original environment.

Let's look at the following example, where we've annotated each line
with the environment at that line.

```
(* [] *)
x := 1     
(* [("x", 1)] *)
{
  (* [("x", 1)] *)
  x := 2
  (* [("x", 2); ("x", 1)] *) 
  y := 3
  (* [("y", 3); ("x", 2); ("x", 1)] *)
  print x
  (* [("y", 3); ("x", 2); ("x", 1)] *)
}
(* [("x", 1)] *)
print x
(* [("x", 1)] *)
```

The environment is always the same before and after entering a
new scope, because we discard any bindings introduced in that scope.
And since `env` is immutable, we're free to return the same one
that was passed in before evaluating `Scope s`.

## Mutable

The mutable version of `Env` is much messier:

```ocaml
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
```

Here we're using `ref` to create mutability. Notice how many
of the methods (e.g. `push`, `pop`, and `insert`) now return
`unit` instead of an updated `EnvMut.t`.

`eval_exp` remains exactly the same:

```ocaml
let rec eval_exp (env: EnvMut.t) (e: exp): int =
  match e with
  | Int n -> n
  | Var v -> EnvMut.find v env
  | Add (l, r) -> eval_exp env l + eval_exp env r
```

But `eval_stm` changes quite a bit:

```ocaml
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
```

Notice how `eval_stm` now returns `unit`, because we're mutating
the provided `env` variable in place. This version of `eval_stm`
seems cleaner than the immutable version, but we've merely
shifted the complexity elsewhere. We now have to keep track of where
`env` is being mutated across recursive calls.

Now we need `EnvMut.push` and `EnvMut.pop` to make sure that an inner
scope's bindings don't affect an outer scope, and hence the `list list`
type.
