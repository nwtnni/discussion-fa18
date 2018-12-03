# Streams

There are three streams in this folder:

- `counter.ml` is a bi-directional infinite counter

```ocaml
type counter =
| Counter of (int * thunk * thunk)

and thunk = unit -> counter
```

- `tree.ml` is an infinite binary tree

```ocaml
type 'a tree =
| Node of 'a * 'a branch * 'a branch

and 'a branch = unit -> 'a tree
```

- `program.ml` is an infinite OCaml expression

```ocaml
type program =
| If  of bool * thunk * thunk
| Add of thunk * thunk
| Sub of thunk * thunk

and thunk = unit -> program
```


