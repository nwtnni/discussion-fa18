(** Represents a generic infinite binary tree with unique
 * node ID values. Nodes are assigned unique ID values using
 * the following scheme:
 *
 *                    n
 *                   / \
 *                  2n 2n+1
 *)
type 'a tree =
| Node of 'a * 'a branch * 'a branch

and 'a branch = unit -> 'a tree

(* [make generate] creates an infinite binary tree with
 * value [generate node_id] at each node, starting with non-negative
 * node ID [id]. *)
let make (generate: int -> 'a): 'a tree =
  let rec make' id =
    failwith "Unimplemented"
  in
  make' 0

(** [left t] is the left subtree of tree [t]. *)
let left (t: 'a tree) : 'a tree =
  failwith "Unimplemented"

(** [right t] is the right subtree of tree [t]. *)
let right (t: 'a tree) : 'a tree =
  failwith "Unimplemented"

(** [value t] is the value at the root of tree [t]. *)
let value (t: 'a tree) : 'a =
  failwith "Unimplemented"

(** [map f t] is tree [t] with [f] applied to the value at every node *)
let rec map (f: 'a -> 'b) (t: 'a tree) : 'b tree =
  failwith "Unimplemented"

(** Represents a generic finite binary tree *)
type 'a finite =
| FLeaf
| FNode of 'a * 'a finite * 'a finite

(** [take depth t] is the finite subtree of [t] with depth [depth]. *)
let rec take (depth: int) (t: 'a tree) : 'a finite =
  failwith "Unimplemented"
