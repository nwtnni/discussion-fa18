(** Represents a generic infinite binary tree *)
type 'a tree =
| Node of 'a * 'a branch * 'a branch

and 'a branch = unit -> 'a tree

(* [make generate] creates an infinite binary tree with
 * value [generate node_id] at each node, where the root has ID 0.
 * Nodes are assigned unique ID values using the following scheme:
 *
 *                    n
 *                   / \
 *                  2n 2n+1
 *)
let make (generate: int -> 'a): 'a tree =
  let rec make' id =
    let l = fun () -> make' (2 * id) in
    let r = fun () -> make' (2 * id + 1) in
    Node (generate id, l, r) 
  in
  make' 0

(** [left t] is the left subtree of tree [t]. *)
let left (t: 'a tree) : 'a tree =
  match t with
  | Node (_, l, _) -> l ()

(** [right t] is the right subtree of tree [t]. *)
let right (t: 'a tree) : 'a tree =
  match t with
  | Node (_, _, r) -> r ()

(** [value t] is the value at the root of tree [t]. *)
let value (t: 'a tree) : 'a =
  match t with
  | Node (v, _, _) -> v

(** [map f t] is tree [t] with [f] applied to the value at every node *)
let rec map (f: 'a -> 'b) (t: 'a tree) : 'b tree =
  let v' = f (value t) in
  let l' = fun () -> map f (left t) in 
  let r' = fun () -> map f (right t) in
  Node (v', l', r')

(** Represents a generic finite binary tree *)
type 'a finite =
| FLeaf
| FNode of 'a * 'a finite * 'a finite

(** [take depth t] is the finite subtree of [t] with depth [depth]. *)
let rec take (depth: int) (t: 'a tree) : 'a finite =
  if depth = 0 then FLeaf else
  let l' = take (depth - 1) (left t) in
  let r' = take (depth - 1) (right t) in
  FNode (value t, l', r')
