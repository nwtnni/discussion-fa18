open Ast

module M = Map.Make (String)
module S = Set.Make (String)

(** Monadic bind operator for option types *)
let (>>=) opt f = match opt with
| None -> None
| Some v -> f v

(** Free variables of a term *)
let rec free = function
| Var x -> S.singleton x
| Abs (x, e) -> S.remove x (free e)
| App (e1, e2) -> S.union (free e1) (free e2)

(** Adds backticks incrementally to string [y] *)
let incr y =
  let counter = ref None in
  fun () -> match !counter with
  | None   ->
    counter := Some 1;
    y
  | Some n ->
    counter := Some (n + 1);
    y ^ (String.make n '\'')

(** Renames variables to avoid capture *)
let rec rename fvs x ctx = function
| Var y ->
  begin match M.find_opt y ctx with
  | Some y' -> Var y'
  | None -> Var y
  end
| App (e1, e2) ->
  App (rename fvs x ctx e1, rename fvs x ctx e2)
| Abs (y, e) ->
  let y' = ref y in
  let next = incr y in
  while !y' = x || S.mem !y' fvs do
    y' := next ()
  done;
  let ctx' = M.add y !y' ctx in
  Abs (!y', rename fvs x ctx' e)

(** Performs capture-avoiding substitution for e[v/x] *)
let sub e v x =
  let rec sub' v x = function
  | Var y when x = y -> v
  | Var y -> Var y
  | Abs (y, e) -> Abs (y, sub' v x e)
  | App (e1, e2) -> App (sub' v x e1, sub' v x e2)
  in
  let fvs = free v in
  rename fvs x M.empty e |> sub' v x

(** Implements call-by-value small-step semantics *)
let rec step_by_value = function
| App (Abs (x, e1), e2) when Ast.is_value e2 ->
  Some(sub e1 e2 x)
| App (e1, e2) when Ast.is_value e1 ->
  step_by_value e2 >>= fun e2' ->
  Some (App (e1, e2'))
| App (e1, e2) ->
  step_by_value e1 >>= fun e1' ->
  Some (App (e1', e2))
| _ -> None

(** Implements call-by-name small-step semantics *)
let rec step_by_name = function
| App (Abs (x, e1), e2) ->
  Some (sub e1 e2 x)
| App (e1, e2) ->
  step_by_name e1 >>= fun e1' ->
  Some (App (e1', e2))
| _ -> None

(** Implements full beta reduction small-step semantics *)
let rec step_by_full = function
| App (Abs (x, e1), e2) ->
  Some (sub e1 e2 x)
| App (e1, e2) ->
  begin match step_by_full e1 with
  | None -> step_by_full e2 >>= fun e2' -> Some (App (e1, e2'))
  | Some e1' -> Some (App (e1', e2))
  end
| Abs (x, e) ->
  step_by_full e >>= fun e' ->
  Some (Abs (x, e'))
| _ -> None

(** Parse file [f] into a lambda term *)
let parse_file f = f
  |> open_in
  |> Lexing.from_channel
  |> Parser.exp Lexer.token

(** Parse string [s] into a lambda term *)
let parse s = s
  |> Lexing.from_string
  |> Parser.exp Lexer.token

(** Apply expression [e] sequentially to expressions [es] *)
let apply e es =
  List.fold_left (fun acc app -> App (acc, app)) e es

(** Recursively call [f] until it returns None *)
let rec fix f =
  fun e -> match f e with
  | None -> e
  | Some e' -> (fix f) e'

(** Helper function for converting step to eval functions *)
let eval f =
  fix begin fun e ->
    print_endline (Ast.to_string e);
    f e
  end

(** Big-step equivalents of small-step semantics (with step printing) *)
let eval_by_value = eval step_by_value
let eval_by_name = eval step_by_name
let eval_by_full = eval step_by_full
