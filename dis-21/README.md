# Monadic Error Handling and Coq

The plan for today is to do a brief review of monads for error handling (important for A9!),
followed by some practice with basic Coq proofs.

## Result

Here's what the result type looks like:

```ocaml
type ('ok, 'err) result =
| Val of 'ok
| Exn of 'err

let (>>=) result f = match result with
| Val v -> f v
| Exn e -> Exn e
```

For our simple interpreter, the `'ok` and `'err` types are:

```ocaml
type ok =
| Unit
| Bool of bool
| Int of int

type err =
| ExpectedInt
| ExpectedBool
```

## Coq

We'll be working with [Church numerals][1] and some basic logical connectives today.

The former is some practice writing simple functions in Coq, and the latter is
proving some basic theorems. Some good references for tactics include the
[3110 Coq Cheatsheet][2] and the [Coq tactic index][3].

[1]: https://en.wikipedia.org/wiki/Church_encoding#Church_numerals
[2]: http://www.cs.cornell.edu/courses/cs3110/2018fa/lec/20-coq-fp/cheatsheet.html
[3]: https://pjreddie.com/coq-tactics/#apply
