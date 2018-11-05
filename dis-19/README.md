# Environments

The environment model is a way of mapping identifiers to some value.
Environments go by many names: `context`, `store`, `map`, and so on.
For example, in type-checking, we use environments to map
variable names to their types. In interpretation, we use environments to
map variable names to their values.

## Plus

To get some practice with the environment model, we'll be implementing
an interpreter for a bare-bones programming language that we'll 
call `Plus` (because that's about all it can do). In `Plus`, there
are expressions, which evaluate to integers, and statements, which
don't evaluate to anything, but produce side effects:

### Expressions

```ocaml
type exp =
| Int of int       (* Integer *)
| Var of string    (* Variable *)
| Add of exp * exp (* Addition *)
```

### Statements

```ocaml
type stm =
| Assign of string * exp (* Variable assignment implemented via environment *)
| Seq of stm * stm       (* Two statements in sequence *)
| Print of exp           (* Prints an expression *)
| Scope of stm           (* Creates a new scope for variable bindings *)
```

## Example `Plus` Programs

Printing a number:

```
print 5
```

Assigning to a variable:

```
x := 5
print x
```

Nested scopes:

```
x := 1
{
  x := 2
  print x
}
print x
```

## TODO

Your job is to implement the following three functions in `eval.ml`:

**Env.find** looks up a variable in the current environment

```ocaml
let rec find (v: string) (env: t) =
  (* TODO *)
```

**eval_exp** evaluates an expression to a value in the given environment:

```ocaml
let rec eval_exp (env: Env.t) (e: exp) : int =
  failwith "Unimplemented"
```

**eval_stm** executes a statement in the given environment:

```ocaml
let rec eval_stm (env: Env.t) (s: stm): unit =
  failwith "Unimplemented"
```

## Testing

You can find example `Plus` programs in the `test` directory. Use `make`
to compile your code, and then you can run `./eval.byte test/<FILE>` to
interpret a `Plus` file.
