# FAQ

### *Q: What's the difference between a module and a signature?*

Let's go back to Java for a bit. Here's a simple interface for an
object that generates numbers:

```java
public interface Generator {

    public int generateNumber();

}
```

Is the following statement legal?

```java
Generator generator = new Generator();
```

No, because you can't instantiate a `Generator`: it's just
an interface, not a concrete class. For illustration, suppose Java
did allow you to create a `Generator`--what would the value of
the following line be?

```java
generator.generateNumber()
```

There's no implementation for the `generateNumber` method, so there's
no reasonable value to return. Similarly in OCaml, we could define a
signature:

```ocaml
module type Generator = sig

  val generate_number: unit -> int

end
```

You can't evaluate `Generator.generate_number ()` for the same reason:
a signature doesn't define an implementation, so you can't directly call
functions on the signature.

### *Q: What's an abstract type?*

Abstract types are useful for hiding implementation details. Just like
`private` instance variables in Java, an abstract type allows us to
restrict how the type can be used by the outside world. Consider the
following Java class:

```java
public class PositiveInteger {
    private int n;

    // Override default constructor so it can't be seen from the outside
    private PositiveInteger() {}

    public static PositiveInteger make(int n) {
        if (n < 0) {
          return null;
        } else {
          PositiveInteger integer = new PositiveInteger();
          integer.n = n;
          return integer;
        }
    }

    public int get() {
        return this.n;
    }
}
```

What invariants does it enforce on the value of `n`? Is it possible
to make a `PositiveInteger` object whose `get` method returns a negative
integer? Let's translate back to OCaml:

```ocaml
(* positive.ml *)

module type Positive = sig

  type t

  val make: int -> t option

  val get: t -> int

end

module IntegerPrivate : Positive = struct

  type t = int

  let make n =
    if n < 0 then None else Some n

  let get n = n

end

module IntegerPublic : (Positive with type t = int) = struct

  type t = int

  let make n =
    if n < 0 then None else Some n

  let get n = n

end
```

What's the difference between the `IntegerPrivate` and `IntegerPublic`
modules? Try these expressions out in `utop`:

```ocaml
let n: IntegerPrivate.t = -5;;
let n: IntegerPublic.t = -5;;
```

How does an abstract type allow us to enforce invariants here? Can you
ever construct an invalid `IntegerPrivate.t`? (And why does `make` return
a `t option` instead of a `t`?)

### *Q: I still don't understand interface sealing and sharing constraints.*

They're pretty nuanced, so don't worry if you don't immediately understand
all of the edge cases. I'd recommend just experimenting with `zero.ml` in
`utop`--and reading the textbook chapters on [signatures][1], [abstract types][2],
and [sharing constraints][3]--until you understand why things evaluate the
way they do.

I've also included another simple file `seal.ml`, reproduced below:

```ocaml
(* seal.ml *)

module type Seal = sig

  type t

  val trivial: t

end

module Constant = struct

  type t = int

  let trivial = 0

  let meaning_of_life = 42

end

module ConstantConstrained : Seal = struct

  type t = int

  let trivial = 0

  let meaning_of_life = 42

end
```

This file demonstrates how an explicit signature "seals" away any
declarations in a module that aren't a part of the signature. Try using
this file in `utop` and evaluating the following expressions:

```ocaml
Constant.trivial;;
Constant.meaning_of_life;;
ConstantConstrained.trivial;;
ConstantConstrained.meaning_of_life;;
```

# Pair

Solutions to `pair.ml` are included in `pair_sol.ml` file. I highly recommend
trying to implement `FunctionPair` on your own first before looking at the
solutions--you can never get too much practice with higher-order functions.

This part is otherwise a little more straightforward, so I'm not going to do
a detailed writeup. Shoot me an e-mail if you have any questions!

[1]: http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/signatures.html
[2]: http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/abstract_types.html
[3]: http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/sharing_constraints.html
