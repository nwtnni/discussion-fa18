# Red Black Trees

## Invariants

1. Every red node has two black children
2. Every path from root to leaf contains the same number of black nodes

Implement `rep_ok` early on and use it for debugging!

## Insertion

Three phases:

1. Traverse downward
2. Rebalance on the way up
3. Blacken resulting tree

Compare and contrast:

```ocaml
(* Traversal only *)
let rec f x = function
| Leaf           -> ...
| Node (l, v, r) -> match C.compare x v with
                    | LT -> f x l
                    | EQ -> ...
                    | GT -> f x r
```

```ocaml
(* Traverse and modify *)
let rec f x = function
| Leaf           -> ...
| Node (l, v, r) -> match C.compare x v with
                    | LT -> Node (f x l, v, r)
                    | EQ -> ...
                    | GT -> Node (l, v, f x r)
```

```ocaml
(* Traverse, modify, and post-process *)
let rec f g x = function
| Leaf           -> ...
| Node (l, v, r) -> match C.compare x v with
                    | LT -> g (Node (f x l, v, r))
                    | EQ -> ...
                    | GT -> g (Node (l, v, f x r))
```

## Deletion

Two phases:

1. Redden initial tree
2. Find and remove inorder successor
3. Rotate on the way up (implicitly rebalances with `rotate` function)
