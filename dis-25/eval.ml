open Ast

module S = Set.Make (String)

let (>>=) opt f = match opt with
| None -> None
| Some v -> f v

let rec free = function
| Var x -> S.singleton x
| Abs (x, e) -> S.remove x (free e)
| App (e1, e2) -> S.union (free e1) (free e2)

let rec sub e v x =
  let rec rename = function
  | Var y -> Var y
  | App (e1, e2) -> App (rename e1, rename e2)
  | Abs (y, e) ->
    let e' = rename e in
    let y' = ref y in
    let fvs = free e' in
    let incr =
      let counter = ref None in
      fun () -> match !counter with
      | None   -> counter := Some 0;
      | Some n -> counter := Some (n + 1); y' := (y ^ (string_of_int n))
    in
    while !y' = x || S.mem !y' fvs do
      incr ()
    done;
    Abs (!y', e')
  in

  let rec sub' v x = function
  | Var y when x = y -> v
  | Var y -> Var y
  | Abs (y, e) -> Abs (y, sub' v x e)
  | App (e1, e2) -> App (sub' v x e1, sub' v x e2)
  in

  rename e |> sub' v x

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
