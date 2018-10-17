# Mutability

Surprise! We actually do have mutable types in OCaml. From now on, we'll be 
allowing you to use them.

## Refs

A ref cell is like a pointer in an imperative language. You can set a ref to 
point to a memory location, and change the contents of that memory location.
Like the pointers we're used to, refs can be dereferenced and referenced as follows:

```ocaml
(* create a reference *)
# let month = ref "Oct";;
val month : string = {contents = "Oct"}

(* Dereferencing to get the value *)
# !month;;
- : string = "Oct"

(* Assigning a new value *)
# month := "Nov";;
- : string = "Nov"
```

Aliasing can also occur, when we have two or more pointers point to the same memory location. When this happens, updating the content at this memory location will alter the value of both pointers.

## Semicolon
Now that we can mutate refs, we don't always have a meaningful output to our evalutations. (Note that the output to a mutation is not the new value, but rather it is unit). Perhaps we want to change the value at the end of a pointer, but we don't want to return the output of that operation (which will be a unit). 

We use ; to denote this. We can chain multiple operations with ; to do a bunch of mutations back to back while suppressing the output.

For example:

```ocaml
e1 ; e2 : t (* will evaluate to t *)

```

## Mutable Fields
We can also make the fields of a record mutable, so we can easily change them. This is done using the keyword `mutable`. For example:

```ocaml
type 'a ref = {mutable contents : 'a; }
```

This is actually how references work! They are defined as records with one element, which is a mutable of type 'a. We can change the contents all we want and the ref will still point to the same memory location. 

To update a mutable field:
```ocaml
# type name = {mutable n : string};;

# let b = {n = "Bob"};;
val b : name = {n = "Bob"}

# b;;
- : name = {n = "Bob"}

# b.n <- "Joe";;
- : unit = ()

# b;;
- : name = {n = "Joe"}
```

For today's exercise, we'll be implementing lists with mutable elements using mutable fields. For a challenge, extend this so the list itself is mutable!