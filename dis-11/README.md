# Testing

For this discussion, we'll be testing against the `Trie` module, which
implements a string set using a [trie][1] data structure. The interface
is the same as the other sets we've seen in past:

```ocaml
(** Abstract type representing a string set. *) 
type t

(** Empty set. *)
val empty : t

(** Converts a set into an unordered string list. *)
val to_list : t -> string list

(** [insert s set] is the set [set] after inserting string [s]. *)
val insert : string -> t -> t

(** [contains s set] is true iff [s] is in [set]. *)
val contains : string -> t -> bool

(** [remove s set] is the set [set] after removing string [s].
    Does nothing if [s] is not in the set.
*)
val remove : string -> t -> t
```

# Black Box Testing

Start by writing black box tests against the interface *without* looking
at the trie implementation. Think about edge cases! The `empty`, `insert`, and
`to_list` functions are implemented correctly (I think), so you can rely on them in
your test suite. Try to write tests that expose the bugs in the `contains` and
`remove` functions..

# Implementation Fix

Once you have a test suite that exposes the bugs, try to look through `trie.ml` and
fix the implementation.

# Glass Box Testing

Finally, if you have time remaining, you can try to write more tests to achieve full
code coverage.

[1]: https://en.wikipedia.org/wiki/Trie
