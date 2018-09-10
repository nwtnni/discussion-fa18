# Variants

For this discussion, we'll be implementing a basic calculator using variant data structures!

You'll be able to:

- Convert to and from strings
- Write recursive functions on arithmetic expressions
- Evaluate expressions

## Constant Variants

The following type represents an arithmetic binary operator:

```ocaml
type binop =
| Add
| Mul
```

Operators can either be addition or multiplication.

## Tagged Variants

The following type represents a numeric value:

```ocaml
type value =
| Inf
| Int of int
```

Values can be a single digit number or infinity.

## Recursive Variants

The following type represents an arithmetic expression:

```ocaml
type exp =
| Value of value
| Binop of binop * exp * exp
```

Expressions can either be a numeric value, or nested binary operations.
