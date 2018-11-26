type t =
| Var of string
| Abs of string * t
| App of t * t

let rec to_string = function
| Var x -> x
| Abs (x, e) ->
  Printf.sprintf
    "λ%s. %s"
    x
    (to_string e)
| App (Abs (_, _) as e, (Abs (_, _) as e')) ->
  Printf.sprintf
    "(%s) (%s)"
    (to_string e)
    (to_string e')
| App (Abs (_, _) as e, e') ->
  Printf.sprintf "(%s) %s"
    (to_string e)
    (to_string e')
| App (e, (App (_, _) as e'))
| App (e, (Abs (_, _) as e')) ->
  Printf.sprintf
    "%s (%s)"
    (to_string e)
    (to_string e')
| App (e, e') ->
  Printf.sprintf
    "%s %s"
    (to_string e)
    (to_string e')
