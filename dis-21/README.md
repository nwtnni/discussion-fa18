# Monadic Error Handling and Coq

The plan for today is to do a brief review of monads for error handling (important for A9!),
followed by some practice with basic Coq proofs.

# Result

Here's what the result type looks like:

```ocaml
type ('ok, 'err) result =
| Val of 'ok
| Exn of 'err

let (>>=) result f = match result with
| Val v -> f v
| Exn e -> Exn e
```
