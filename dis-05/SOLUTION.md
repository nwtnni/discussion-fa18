# Solution Writeup

For reference, here are the types we defined:

```ocaml
type binop =
| Add
| Mul

type value =
| Inf
| Int of int

type exp =
| Value of value
| Binop of binop * exp * exp
```

## Option and Parsing

Let's start off with basic binary operators.

```ocaml
let binop_of_char (c: char) : binop option = match c with
| '+' -> Some Add
| '*' -> Some Mul
| _   -> None
```

Here, the type of `binop_of_char` is `char -> binop option`. Why `option`?
It's to reflect that not all `char` values have a meaningful `binop` translation.
In general, we use `option` types to implement **partial functions**: functions
that aren't defined on all inputs.

Compare the `option` type to Java `null` values: in Java, these two methods
have the same type signature:

```java
public String returnString() {
    return "foo";
}

public String returnNull() {
    return null;
}
```

Just from reading the signature of a method, you have no idea if or when it could
return `null`! In OCaml, however, a `string option` is a completely different type
than a `string`. You can't pass a `string option` to a function expecting a `string`,
and vice versa--you also can't return a `string option` from a function that's
supposed to return a `string`, and vice versa.

```ocaml
let return_string (_: unit) : string = "foo"

(* Type error! *)
let return_none_wrong (_: unit) : string =
  None

(* Compiles *)
let return_none_correct (_: unit) : string option =
  None
```

You can tell just from reading the function signature whether it's able to
return a `None` value, and the compiler forces you to match on the `option`
value before you can use the inner value. You can **never** accidentally
forget to handle the `None` case, and you never *need* to handle it unless
you have an explicit `option` type. Contrast this with defensive programming
in Java:

```java
if (someVariable == null || thatVariable == null) {
    return null;
}
```

Okay, so why doesn't this function return a `string option`?

```ocaml
let string_of_binop (o: binop) : string = match o with
| Add -> "+"
| Mul -> "*"
```

Because it's a **total function**: it's well-defined for all inputs, and
so we don't `option` to describe the return type.

## Patterns and Variant Construction

Take a look at this parsing function: again, we're returning a `value option`
because not all characters have meaningful `value` counterparts.

```ocaml
let value_of_char (c: char) : value option = match c with
| '0'..'9' -> Some (Int (Char.code c - 48))
| 'i'      -> Some Inf
| _        -> None
```

Here's a more obscure pattern that might come in handy for A1: `'0'..'9'`
matches all characters `'0'` to `'9'`, inclusive. On the right hand side,
we need to wrap variant constructors in parentheses to force evaluation
order. If we just wrote the following code:

```ocaml
Some Int 5
```

OCaml would try to parse this as a function call to `Some` with two arguments `Int` and `5`.

The deparsing code is straightforward:

```ocaml
let string_of_value (v: value) : string = match v with
| Inf   -> "i"
| Int i -> string_of_int i
```

Here we see the pattern for variants that carry data: `Int i` matches the `Int` variant, and
`i` matches its `int` contents. `string_of_int` is a function in the standard library
(in the Pervasives module, so it's always in scope).

## More Parsing

Here we define a recursive parsing function that essentially iterates through
the input string. Notice again the `exp option` return type: strings like
`aabacd` and `bar` have no `exp` translation, so we'd return `None`.

```ocaml
let rec exp_of_string (s: string) : exp option = match String.length s with
| 0 -> None
| 1 ->
    begin match value_of_char s.[0] with
    | Some v -> Some (Value v)
    | None   -> None
    end
| l when l > 2 ->
    let e1 = value_of_char s.[0] in
    let op = binop_of_char s.[1] in
    let e2 = exp_of_string (String.sub s 2 (l - 2)) in
    begin match (e1, op, e2) with
    | (Some e1, Some op, Some e2) -> Some (Binop (op, Value e1, e2))
    | _                           -> None
    end
| _ -> None
```

There are a few important cases to consider:

- Empty string: Nothing to return.
- Single character: Must be an integer, so we'll try parsing it with `value_of_char`.
- Three or more characters: must be something in the form `n*...` or `n+...`, so
  we parse the first two characters and recurse on the rest of the string.
- Anything else: can't possibly be valid input. Left as a thought exercise for the reader.

Notice how matching on a tuple allows us to check that all three parsed
values are valid at once:

```ocaml
begin match (e1, op, e2) with
| (Some e1, Some op, Some e2) -> Some (Binop (op, Value e1, e2))
| _                           -> None
```

Contrast this with trying to linearly match on `e1`, then `e2`, then `e3`:

```ocaml
match e1 with
| Some e1 -> begin match op with
             | Some op -> begin match e2 with
                          | Some e2 -> Some (Binop, (op, Value e1, e2))
                          | None -> None
                          end
             | None -> None
             end
| None -> None
end
```

Once we get to higher-order functions, you'll learn even more convenient ways
to work with `option` types!

## Functions on Recursive Variants

Think about the similarities and differences between the following functions:

```ocaml
let rec string_of_exp (e: exp) : string = match e with
| Value v            -> string_of_value v
| Binop (op, e1, e2) -> (string_of_exp e1) ^ (string_of_binop op) ^ (string_of_exp e2)
```

```ocaml
let rec evaluate (e: exp) : value = match e with
| Value v -> v
| Binop (op, e1, e2) ->
  let v1 = evaluate e1 in
  let v2 = evaluate e2 in
  match (op, v1, v2) with
  | (Add, Int i1, Int i2) -> Int (i1 + i2)
  | (Mul, Int i1, Int i2) -> Int (i1 * i2)
  | _                     -> Inf
```

```ocaml
let rec count_infinity (e: exp) : int = match e with
| Value Inf     -> 1
| Value (Int _) -> 0
| Binop (_, e1, e2) -> (count_infinity e1) + (count_infinity e2)
```

```ocaml
let rec add_one (e: exp) : exp = match e with
| Value Inf          -> Value Inf
| Value (Int i)      -> Value (Int (i + 1))
| Binop (op, e1, e2) -> Binop (op, add_one e1, add_one e2)
```

When we recurse on `int`s or `list`s, we only have one base case and one
recursive case. But for a general recursively defined type, we can have:

- One or more base cases
- Zero or more recursive cases

Each of these functions does just that!

## Note on Begin and End Keywords

Nested match statements require either parentheses or `begin` and `end` keywords to
explicitly mark where the cases end. For example:

```ocaml
let _ = match ["hello"] with
| h :: t -> match h with
            | "hello" -> "world"
            | _       -> "foo"
| []     -> "bar"
```

How does the compiler tell the difference between that snippet and this one?

```ocaml
let _ = match ["hello"] with
| h :: t -> match h with
            | "hello" -> "world"
| _      -> "foo"
| []     -> "bar"
```

It's ambiguous, so you need to do one of the following:

```ocaml
let _ = match ["hello"] with
| h :: t -> begin match h with
            | "hello" -> "world"
            | _      -> "foo"
            end
| []     -> "bar"

let _ = match ["hello"] with
| h :: t -> (match h with
            | "hello" -> "world"
            | _      -> "foo"
            )
| []     -> "bar"
```

Mostly personal preference as to which. This only is an issue if a match statement
could overlap with another one. For example, the following code presents no problems:

```ocaml
let _ = match ["hello"] with
| h :: t -> let s = match h with
            | "hello" -> "world"
            | _      -> "foo"
            in s
| []     -> "bar"
```

Because the `let` expression "splits" the two match expressions apart.
