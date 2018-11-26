open Ast

module S = Set.Make (String)

let (>>=) opt f = match opt with
| None -> None
| Some v -> f v

let rec free = function
| Var x -> S.singleton x
| Abs (x, e) -> S.remove x (free e)
| App (e1, e2) -> S.union (free e1) (free e2)

let rec sub e v x = failwith "Unimplemented"

and step_by_value = function
| App (Abs (x, e1), e2) when Ast.is_value e2 ->
  Some(sub e1 e2 x)
| App (e1, e2) when Ast.is_value e1 ->
  step_by_value e2 >>= fun e2' ->
  Some (App (e1, e2'))
| App (e1, e2) ->
  step_by_value e1 >>= fun e1' ->
  Some (App (e1', e2))
| _ -> None

and step_by_name = function
| App (Abs (x, e1), e2) ->
  Some (sub e1 e2 x)
| App (e1, e2) ->
  step_by_name e1 >>= fun e1' ->
  Some (App (e1', e2))
| _ -> None

