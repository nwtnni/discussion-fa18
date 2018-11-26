type 'a recurse =
| Recurse of ('a recurse -> 'a -> 'a)

let pre_fact (Recurse f: int recurse) (n: int) =
  if n = 0 then 1 else n * ((f (Recurse f)) (n - 1))

let fact =
  pre_fact (Recurse pre_fact)
