# Testing

This exercise was meant to show the benefits of both black box testing and glass box testing.

Black box testing allows you to write tests before even looking at the implementation, but
the downside is that it may be hard to catch obscure bugs--you might never test code paths
that you don't know about.

Glass box testing requires some familiarity with the codebase you're testing, but the benefit
is that you can be more assured of correctness when all paths are covered by tests.

In this case, since the bugs were in branches specific to tries, it was harder to find them
via black box testing. Someone who know the set was implemented with a trie could target
more trie-specific edge cases, like adding and removing substrings.

# Trie

A trie is essentially a tree data structure for representing strings. The one implemented here
is fairly inefficient because it doesn't do any compression, but is good enough to satisfy
a basic set interface.

## Type

A trie, like a tree, is a recursive data structure consisting of nodes.
We represent nodes using the following record type:

```ocaml
module M = Map.Make (Char)

type t = {
  word: bool;
  next: t M.t;
}
```

Here we apply the `Map.Make` functor from the standard library to the `Char` module
to construct an `M` module. The `'a M.t` type represents maps from `Char.t` to `'a`.

Our nodes need to keep track of two things: whether or not they mark the end
of a word in the set, and their outgoing edges to their children. The
`node.word` marker tells us if this node is the end of a valid word, and the
`node.next` field is a map from characters to child nodes. The following examples
might help illustrate this:

## Examples

Here `x` denotes a node whose `node.word` field is true, and `o` denotes
a node whose `node.word` field is false.

`{}`:

```
              o
```

`{""}`:

```
              x
```

`{"a"}`:

```
              o
              | a
              x
```

`{"a", "b"}`:

```
              o
           a / \ b
            x   x
```

`{"ab", "b"}`:

```
              o
           a / \ b
            o   x
          b |
            x
```

`{"a", "abc", "b"}`:

```
              o
           a / \ b
            x   x
          b |
            o
          c |
            x
```

`{"a", "abc", "abd", "b"}`:

```
              o
           a / \ b
            x   x
          b |
            o
         c / \ d
          x   x
```

## Contains

We'll start with the `contains` function, which is probably the simplest. Intuitively,
given some input string `s`, we want to follow the trie character by character:

```ocaml
let rec contains' cs node = match cs with
| []     -> ...
| c :: t -> ...
```
Let's think about this recursively. Are the following equivalent?

Searching for `"abc"` in this trie:

```
    o
    | a
    o
    | b
    o
    | c
    x
```

and searching for `"bc"` in this trie:

```
    o
    | b
    o
    | c
    x
```

If our original input is `s = c :: t`, this suggests that our
recursive case can search the subtree `Map.find c node.next` for `t`:

```ocaml
...
| c :: t -> match M.find_opt c node.next with
            | Some step -> contains' t step
            ...
```

But what if `node.next` doesn't contain the key `c`? That would
correspond to something like searching for `"ab"` in the following trie:

```
    o
    | a
    o
 a / \ c
  x   x
```

Clearly the trie doesn't contain the string we want, since the path
ends early, so we can just return `false`.

```ocaml
...
| c :: t -> match M.find_opt c node.next with
            | Some step -> contains' t step
            | None      -> false
```


What about the base case? Well, if we keep following the path of characters
down the trie, we'll end up with no characters left. See the following
example of searching for `"abc"`:

```
  o           o           o           x
  | a         | b         | c
  o           o           x
  | b   ==>   | c   ==>         ==>
  o           x
  | c
  x
```

If our original search was in the trie, then the node we arrive at should
have its `node.word` field set to `true`. Otherwise it wasn't actually a word in
the trie, like searching for `"abc"` again in the new trie below:

```
  o           o           o           o
  | a         | b         | c         | d
  o           o           o           x
  | b   ==>   | c   ==>   | d   ==>
  o           o           x
  | c         | d
  o           x
  | d
  x
```

So our base case is:

```ocaml
let rec contains' cs node = match cs with
| []     -> node.word
...
```

And that's our whole `contains` function!

```ocaml
let rec contains' cs node = match cs with
| []     -> node.word
| c :: t -> match M.find_opt c node.next with
            | None      -> false
            | Some step -> contains' t step
```

## Plumbing

You'll notice that we write `insert = plumb insert'`, `contains = plumb contains'`, and
so on. This is because it's nicer to pattern match on the `char list` type than
the `string` type. So all of our primed functions---`insert'`, `contains'`, `remove'`---take
in `char list`s, and the `plumb` function is a higher-order wrapper function that lets them
take in `string`s instead.

```ocaml
let rec explode (s: string) : char list = match String.length s with
| 0 -> []
| n -> s.[0] :: explode (String.sub s 1 (n - 1))

let plumb f =
  fun s -> f (explode s)
```

Note that these are equivalent (partial application!):

```ocaml
let plumb f =
  fun s -> f (explode s)

let plumb f =
  fun s node -> f (explode s) node
```

## Insert

Insert has the same skeleton as `contains`, but the logic is a little more complex because we
may have to create new nodes as we descend through the tree.

```ocaml
let rec insert' cs node = match cs with
| []     -> ...
| c :: t -> match M.find_opt c node.next with
            | None      -> ...
            | Some next -> ...
```

Note that functional data structures are **immutable**: they return a new updated
copy instead of mutating in-place. So what's our base case? Suppose we want to
insert the empty string: `""` into the empty trie:

```
    o   ==>   x
```

What about a non-empty trie?

```
    o               x
    | a             | a
    o      ==>      o
 b / \ c         b / \ c
  x   x           x   x
```

We just look at the current node and set its `node.word` field.
So our base case should be:

```ocaml
let rec insert' cs node = match cs with
| []     -> { node with word = true }
...
```

For the recursive case, either the child already exists or it doesn't.
Here's an example of each: suppose we insert `a` into the following tries:

```
    o
    | a
    o
    | b
    x
```

and

```
    o
```

In the first case, if `s = c :: t`, we want to take a step and insert
the rest of the string into the child node.

```ocaml
...
| c :: t -> match M.find_opt c node.next with
            | Some next -> let step = insert' t next in
                           { node with next = M.add c step node.next }
            ...
```

The tricky thing here is the `M.add c step node.next` bit: why are we
calling `M.add`? Well, `insert' t next` doesn't mutate the `next`
node. In order to update the current node with the new child, we have
to explicitly rebind it to `c` in the `node.next` map. Otherwise we
wouldn't see the changes to the `next` child in our `node.next` map!

In the second case, there's no `c` edge from our current node. So we
can pretend one exists by inserting into an `empty` node instead:

```ocaml
  | c :: t -> match M.find_opt c node.next with
              | None      -> let step = insert' t empty in
                             { node with next = M.add c step node.next }
```

The logic is otherwise the same as the earlier case, where we have to
use `M.add` to actually return an updated node. So with all three
cases covered, our final `insert` function is:

```ocaml
let rec insert' cs node = match cs with
| []     -> { node with word = true }
| c :: t -> match M.find_opt c node.next with
            | None      -> let step = insert' t empty in
                            { node with next = M.add c step node.next }
            | Some next -> let step = insert' t next in
                            { node with next = M.add c step node.next }
```

## To List

The implementation of `to_list` is pretty short for what it does. Intuitively,
we want to keep track of the current prefix, and then prepend it to any words
in subtrees. Additionally, if the current node marks a word, we want to include
the current prefix in the list. `Map.fold` is a great candidate for this
function: conceptually we're trying to condense some collection of values (a trie)
into a single value (a list).

```ocaml
let rec to_list' prefix node =
  let append c = prefix ^ (String.make 1 c) in
  let fold c next acc = acc @ to_list' (append c) next in
  let subtree = M.fold fold node.next [] in
  if node.word then prefix :: subtree else subtree
```

Here `append` is a helper function for appending a character to a string.
The `fold` function is what we're passing to `Map.fold`. It takes in three
arguments: the current key and value, and some accumulator.
`subtree` is the result of folding over all subtrees, and the last line
checks if we need to add the current prefix to the list.

## Remove

The logic for `remove` is fairly similar to `insert`, so you can hopefully figure it
out on your own!
