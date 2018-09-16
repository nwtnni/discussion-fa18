# Modules 

For this discussion, we'll be experimenting with OCaml's module system.

# Signatures and Sharing Constraints

This section deals with the file `zero.ml`.

We'll be working with the following signature:

```ocaml
(** Represents a type with a zero value. *)
module type Zero = sig

  (** Abstract type. *)
  type t

  (** Zero value. *)
  val zero : t

  (** True if the passed in value is equal to zero. *)
  val is_zero : t -> bool

end
```

Inside the file are five predefined modules: `Free`, `Constrained`,
`Shared`, `FreeConstrained`, and `FreeShared`. This part doesn't require
you to write any new code, but instead we just want you to explore
the following questions interactively in `utop`:

1. What does `utop` print when you evaluate the following expressions?
  - `Zero.zero;;`
  - `Free.zero;;`
  - `Constrained.zero;;`
  - `Shared.zero;;`
  - `FreeConstrained.zero;;`
  - `FreeShared.zero;;`

2. What does `utop` print when you evaluate the following expressions?
  - `Zero.is_zero 0;;`
  - `Free.is_zero 0;;`
  - `Constrained.is_zero 0;;`
  - `Shared.is_zero 0;;`
  - `FreeConstrained.is_zero 0;;`
  - `FreeShared.is_zero 0;;`

3. Why do we get `Unbound module Zero` when we try to call its functions?
   Along the same lines: what's the difference between a signature and a module?

4. After exploring which expressions are legal, try and explain to your
   partner what the differences between each module definition are, and
   when you might want to use a specific one. Review the
   [textbook chapter on sharing constraints][1] if you need to.

#  Implementing Signatures

This section focuses on the `pair.ml` file.

We'll be working with the following signature:

```ocaml
(** Represents a pair data structure.
    Both elements must be the same type.
 *)
module type Pair = sig

  (** Abstract type *)
  type 'a t

  (** Construct a pair *)
  val from: 'a -> 'a -> 'a t

  (** Take the first element of a pair *)
  val fst: 'a t -> 'a

  (** Take the second element of a pair *)
  val snd: 'a t -> 'a

end
```

Here, we've defined two modules `TuplePair` and `FunctionPair`.
The concrete types `'a t` have already been defined for you--your
job is to implement the `from`, `fst`, and `snd` functions. Try
them out in `utop` to see if they work properly.

`FunctionPair` might be trickier to write, but it's good practice with
higher-order functions--it's pretty neat that we can represent pairs
with functions!

# Appendix

**Files vs. Modules**

For each file `module.ml`, OCaml automatically puts all code in that file into
a module named `Module`. Similarly, for each file `module.mli`, OCaml implicitly
defines a signature named `Module`.

**.ocamlinit**

If you have an `.ocamlinit` file in your directory, `utop` will run all the commands
inside it on startup. The `.ocamlinit` file in this directory looks like this:

```
#use "zero.ml";;
#use "pair.ml";;
```

When you open `utop`, it should automatically bring everything in `Zero` and `Pair`
into scope. This can be helpful for speeding up interactive debugging, if you
find yourself typing the same `utop` directives over and over.

[1]: http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/sharing_constraints.html
