# FAQ

### *Q: How is this relevant to lecture?*

It's a little difficult to write exercises for specification that aren't
really boring, but most of them look like this: given some vague
specification for a module or data structure, find ambiguities
and resolve them in updated doc-comments.

There are some interesting questions you can ask about the small interface
we provided--things like raising exceptions or ordering lists--but it
seems most people were pretty caught up in the implementation. So...
that was probably our fault; we could have focused more on the specification
part. The solution code is documented, and there are questions below, but
otherwise we'll refer you to the [textbook exercises][1] if you'd like additional
practice.

### *Q: Why is this so difficult?*

First of all, don't feel bad if you're having trouble with the extra exercises.
Our philosophy is to provide challenging questions in discussion, where you have
the benefit of both your peers and two TA's walking around to help you understand things.
You'll be far more comfortable on exams if you've had experience working through
tricky concepts--if you're confused, please speak up! We're always happy to sit down
and explain things, and you can even schedule some time outside discussion if you
need clarification.

**You're not expected or required to finish these exercises during discussion; they're
purely for your benefit.**

I will note that this format--where you're given a brief overview of a topic,
and then some relevant functions to implement--is exactly how exams have been set up
in the past. Maybe one or two paragraphs of exposition, some type definitions, and
then function templates to fill out. You'll want to be comfortable with grasping a general
idea and then implementing a few short functions in OCaml.

### *Q: How do I improve?*

Experience! Just working on more of these problems, and similar ones from the textbook, is
probably the easiest way to internalize these ideas. You'll note that we're not requiring
you to write a lot of code--once you understand the solution, it fits neatly in a few lines.

Now that you've implemented a multimap, try implementing a map or list:

```ocaml
type ('k, 'v) fn_map = 'k -> 'v

type 'a fn_list = unit -> 'a fn_list
```

You'll find that they're *very* similar to your multimap implementation--and hopefully
you'll be able to generalize the concept to other domains as well. (Keep an eye out for
the streams and laziness lecture coming up).

### *Q: How is this useful in real life?*

A lot of interesting topics involve higher-order functions.
[Asynchronous programming][2] in Javascript and other web-related languages
or frameworks is particularly popular, and requires a lot of reasoning about
callback functions. [Monadic error handling][3] can also be found in many mainstream(ish)
programming languages like [Java][4], [Rust][5], and [Haskell][6].

We'll get to those later in the course!

# Specification

Writing good specifications involves thinking about details and
**edge cases**. Here are some questions you could consider for this
exercise:

```ocaml
val empty: ('k, 'v) t
```

- What does it mean, formally, for a map to be empty?

```ocaml
val insert: ('k, 'v) t -> 'k -> 'v -> ('k, 'v) t
```

- What happens when a key is duplicated?
- What happens when a value is duplicated?

```ocaml
val get: ('k, 'v) t -> 'k -> 'v list
```

- What happens when the key isn't bound in the map?
- What order should the returned list be in?
- Should we care about what order the returned list is in?

```ocaml
val insert_all: ('k, 'v) t -> 'k -> 'v list -> ('k, 'v) t
```

- What order do we insert things?
- Does it matter?
- Can we describe behavior in terms of our `insert` function?

```ocaml
val remove: ('k, 'v) t -> 'k -> 'v -> ('k, 'v) t
```

- What do we do if the key-value pair isn't bound in the map?
- What do we do if there are duplicate (k, v) pairs?

```ocaml
val remove_all: ('k, 'v) t -> 'k -> ('k, 'v) t
```

- What do we do if the key isn't bound?

# Implementation

Intuitively, our multimap type is like an onion. The innermost layer, our base
case, is `empty`:

```ocaml
let empty =
  fun _ -> []
```

And every time we update it with `insert`, we wrap another `if else` layer around it.
The whole thing is basically an updateable chain of `if else` expressions:

```ocaml
if k = k1 then v1 ::
  (if k = k2 then v2 ::
    (if k = k3 then v3 ::
      ...
    )
  )
else
  ...
```

Most of you were tempted to write something like this at first:

```ocaml
match map k with
| [] -> ...
| vs -> ...
```

The main confusing thing about higher-order programming is this concept of
[inversion of control][7]: normally when we write a function in an
imperative language, we think about executing things *now*. When we return a
function, on the other hand, code in that function is to be executed *later*,
by someone else.

In this case, our `map` function doesn't need to be run immediately--it
actually only needs to be run when the user is looking up some value. So what
we return is another function that will be run *later*, when the user needs to
query the map:

```ocaml
let insert map k v = 
  fun k' -> if k = k' then v :: map k' else map k'
```

What this says is--hey, we're just inserting and don't need to do any lookups
right now. When you need to look up some key `k'`, then I'll run this code and
search through `map`.

Interestingly, this means that insertions are constant time operations--we're just
making a new function, not executing it. But lookups, of course, are `O(n)` in the
number of insertions, since we have to apply the functions and recurse for each
insertion.

[1]: http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/abstract/exercises.html
[2]: https://eloquentjavascript.net/11_async.html
[3]: https://medium.com/@huund/monadic-error-handling-1e2ce66e3810
[4]: https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html
[5]: https://doc.rust-lang.org/std/result/
[6]: http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Maybe.html
[7]: https://en.wikipedia.org/wiki/Inversion_of_control
