# Lambda Calculus

Notes based off of [Professor Sampson's 4110 notes on lambda calculus!][1]

The lambda calculus is an incredibly minimal language defined entirely
by function application. There are exactly three forms:

1. Variables (e.g. `x`, `y`, `z`)
2. Abstraction (e.g. functions like `lambda x. x`)
3. Application (e.g. `(lambda x. x) y`)

Here is the corresponding OCaml type:

```ocaml
type t =
| Var of string
| Abs of string * t
| App of t * t
```

The untyped lambda calculus is Turing complete! You can express
arbitrarilyy complex computations using nothing but pure functions.
Today we'll look at some encodings of common types like
numbers, booleans, and pairs.

I've implemented a small-step interpreter to help you see how
lambda terms are evaluated.

# Examples

Here are some examples of lambda calculus terms:

- `λx. x`

The identity function

- `x`

A single free variable

- `λx. λy. y`

A curried function that takes in two arguments and returns the second

- `(λx. x) (λy. y)`

An application of the identity function to itself

# Key Concepts

### Free Variables

A variable `x` in a term is `bound` if there is an enclosing `λx. e`. Otherwise, it is free.

```
(λx. x) x y
     ^  ^ ^
     b  f f
```

### Alpha Equivalence

Intuitively, renaming bound variables doesn't change the meaning of a program. We'd
like `λx. x` and `λy. y` to be equivalent, because they behave identically when applied
to arbitrary input. Terms that are the same up to renaming of bound variables are
called alpha-equivalent.

### Beta Equivalence

Beta equivalence essentially relates to function application. An application
`(λx. e1) e2` becomes `e1{e2 -> x}`, which is `e1` with all instances of
variable `x` replaced by expression `e2`. The process of rewriting `(λx. e1) e2)` into
`e1{e2 -> x}` is called beta reduction, and corresponds to program execution.

### Evaluation Order

There are many possible orders of evaluation. I've implemented call-by-value (CBV),
call-by-name (CBN), and full beta reduction (FBR) here, but there are other
strategies as well.

- CBV (evaluate arguments before calling function)
- CBN (pass arguments unevaluated to function)
- FBR (evaluate anywhere)

# Encodings

Let's get started with some basics! We'll be doing most of our exploration in `utop`,
using the following functions (should be loaded from `.ocamlinit` already).

```ocaml
(** Parse string [s] into a lambda term *)
let parse (s: string) = ...

(** Apply expression [e] sequentially to expressions [es] *)
let apply e es = ...

(** Big-step equivalents of small-step semantics (with step printing) *)
let eval_by_value = ...
let eval_by_name = ...
let eval_by_full = ...
```

### Booleans

Here's one possible definition for `true` and `false`:

```ocaml
let t = parse "lambda t f. t";;
let f = parse "lambda t f. f";;
```

Here's an AND function:

```ocaml
let conj = apply (parse "lambda f a b. a b f") [f];;
```

Let's test it:

```ocaml
apply conj [t; t] |> eval_by_full;;
apply conj [t; f] |> eval_by_full;;
apply conj [f; t] |> eval_by_full;;
apply conj [f; f] |> eval_by_full;;
```

How would you write an OR function? What about an if-else branch?

### Naturals

Here's one possible definition of the natural numbers:

```ocaml
let zero = parse "lambda s z. z";;
let succ = parse "lambda n s z. s (n s z)";;
```

How do we count?

```
let one = apply succ [zero] |> eval_by_full;;
let two = apply succ [one] |> eval_by_full;;
let three = apply succ [two] |> eval_by_full;;
```

How would you implement addition, using just the definitions of `zero` and `succ`?

### Recursion

What happens when we try to evaluate this guy?

```
let omega = parse "(lambda x. x x) (lambda x. x x)";;
```

What about these?

```
let y = parse "lambda f. (lambda x. f (x x)) (lambda x. f (x x))";;
let z = parse "lambda f. (lambda x. f (lambda y. x x y)) (lambda x. f (lambda y. x x y))";;
```

[1]: https://www.cs.cornell.edu/courses/cs4110/2018fa/lectures/lecture13.pdf
