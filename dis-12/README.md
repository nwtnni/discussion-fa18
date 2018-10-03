# Streams

For this discussion, we'll be doing a review of the basic stream implementation
done in lecture.

## Stream Review

A stream is a useful data structure that lets us have infinitely long lists of
information. Some applications of this include listing a sequence of numbers (such
as fibonacci) or reading in input characters or strings from a user.

## Problem: Infinite List = Infinite Memory?

When we use a stream, we want to make sure to only access the elements we need
at any given time. If we attempt to access the entire stream, we can easily get
a stack overflow. This is why we need **delayed evaluation**. 

Delayed evaluation is done by defining our stream tail with a function that will
not be evaluated until that function is called. We will make use of the `unit` 
type as the input of this function. For instance:

```
type 'a stream = 
  | Cons of 'a * (unit -> 'a stream)
```

So what's happening here? You can see that this is very similar to our definition
of lists, but without the `Nil` branch. We don't need `Nil` because a stream has
no end - it is infinite, and so it won't match with the empty list.

In the Cons branch, we are defining an 'a stream as a head ('a) and a tail
(unit -> 'a stream). If we want to access the tail of this stream, this definition
will require us to first call the tail function using something like `fun () -> ...`.
That function call is a **thunk**. It contains a delayed computation that won't
be evaluated until that function, or thunk, is called. 

## Exercises

Go through the provided code for streams in `streams.ml` with the people around you. Make sure to ask any questions now so you understand how streams work before you move on!

Next, you can implement the functions described later in `streams.ml`. If you finish
early, try some of these exercises:

1. Come up with your own functions to apply to streams and write those
2. Improve the documentation of `streams.ml`
3. Write a test suite for `streams.ml`