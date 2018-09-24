# Specifications

For this discussion, we'll be writing the specification for and implementing
a basic [multimap][1]: a generalized map that can store any number of values
per key.

To practice higher-order functions, we'll be representing multimaps as
functions with the following type:

```ocaml
type ('k, 'v) t = 'k -> 'v list
```

That is, a function that takes a key and returns a list of associated values.
Your job is to document the following declarations in `multimap.mli`, and
implement the corresponding functions in `multimap.ml`. Refer to the
[textbook][2] for reminders on how to write good specifications.

```ocaml
val empty: ('k, 'v) t

val insert: ('k, 'v) t -> 'k -> 'v -> ('k, 'v) t

val get: ('k, 'v) t -> 'k -> 'v list
```

[1]: https://en.wikipedia.org/wiki/Multimap
[2]: http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/abstract/intro.html
