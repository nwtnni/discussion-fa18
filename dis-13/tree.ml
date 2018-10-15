type 'a tree =
| Leaf
| R of 'a tree * 'a * 'a tree
| B of 'a tree * 'a * 'a tree

(* Checks that all red nodes have two black children *)
let red_ok t = function
| Leaf        -> failwith "Unimplemented"
| R (l, v, r) -> failwith "Unimplemented"
| B (l, v, r) -> failwith "Unimplemented"

(* Checks that all paths from the root have the same number of black nodes *)
let path_ok t = function
| Leaf        -> failwith "Unimplemented"
| R (l, v, r) -> failwith "Unimplemented"
| B (l, v, r) -> failwith "Unimplemented"

let rep_ok t =
  t |> red_ok |> path_ok

(* [min t] is the minimum value in [t] *)
let min t =
  failwith "Unimplemented"
