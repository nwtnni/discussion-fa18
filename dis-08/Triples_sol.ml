(** 
   In this exercise, we'll take a look at a quick review of modules and 
   signatures, and the use of include and open in modules. Then we'll go through 
   the use of functors and implement our own.
   @author Noam Eshed ne236
*)

(**
   1.  Take a look at module TupleTriple below. It creates a triple with three
   values of type alpha. Fill in the signature "Triple" below to match our 
   module
*)

module type Triple = sig
  (** Declaration of abstract type t *)
  type 'a t

  val create : 'a -> 'a -> 'a -> 'a t

  (** Take the first, second, or third element of a triple *)
  val fst : 'a t -> 'a
  val snd : 'a t -> 'a
  val thr : 'a t -> 'a

end

module TupleTriple : Triple = struct

  (* triple type *)
  type 'a t = ('a * 'a * 'a)

  (* constructor *)
  let create a b c = (a,b,c)
  (* functions to return first, second, and third elements of t *)
  let fst (a, _, _) = a
  let snd (_, b, _) = b
  let thr (_, _, c) = c

end

(** 
   2. Now, implement your own module, TupleTripleExt. This should take advantage of 
   the existing structure TupleTriple, and add one more function. Some simple
   functions you could add are:
    - inc, to add 1 to each element of the triple
    - sum, to find the sum of all elements of the triple
    - rev, to reverse the elements in the triple
   Why would you ever use 'include'? Couldn't we just add these extra functions
   to our original TupleTriple module? Discuss with your group.
   
   Answer:
   In this case, we have TupleTriple readily available, and we could easily just
   add these extra functions to it. However, consider a module which may be intrinsic
   to OCaml, or a module created by a colleague which you don't want to modify directly.
   'include' lets you modify your own version of the module, without having to reach into
   someone else's implementation of it.
*)
module TupleTripleExt : Triple = struct

  include TupleTriple

  (* Add 1 to each triple *)
  let inc (a, b, c) = (a+1, b+1, c+1)

  (* Take the sum of 3 elements *)
  let sum (a, b, c) = a + b + c

  (* Reverse the order of the triple *)
  let rev (a, b, c) = (c, b, a)

end

(** 
   3. Copy and paste TupleTripleExt below, rename it to TupleTripleOpen, and 
   change "include" to "open". What happens? Why is that?

   Answer:
   When we use the keyword "open", the functions in TupleTriple are available
   only within our new module, TupleTripleOpen. Using include, on the other hand,
   makes our old functions in TupleTriple available in the scope of TupleTripleOpen.
   The reason we get an error is because this scope doesn't include our 
   signature! Get rid of the signature (i.e. ": Triple") in TupleTripleOpen to 
   see the difference.
*)
module TupleTripleOpen = struct

  open TupleTriple

  (* Add 1 to each triple *)
  let inc (a, b, c) = (a+1, b+1, c+1)

  (* Take the sum of 3 elements *)
  let sum (a, b, c) = a + b + c

  (* Reverse the order of the triple *)
  let rev (a, b, c) = (c, b, a)

end

(**
   Now, let's look at functors. We've created a new type of Triple, this time
   based on Lists. Discuss it with your partner to make sure you understand
   what it is doing. Why can we use the same signature as before (Triple) on 
   our new module?

   Answer:
   We can use the same signature because we made sure to declare the same
   type and definitions within the new module, with the same types, as 
   TupleTriple. Try to delete one of these required definitions (like fst) and 
   see the error that arises.
*)

module ListTriple : Triple  = struct
  (* triple type *)
  type 'a t = 'a list
  let create a b c = [a;b;c]
  let len_three x = assert(List.length x = 3)

  (* functions to return first, second, and third elements of t *)
  let fst = function 
    | h :: _ -> h
    | _ -> failwith "Not length 3"

  let snd = function 
    | h1 :: (h2 :: t) -> h2
    | _ -> failwith "Not length 3"

  let thr = function 
    | h1 :: (h2 :: (h3 :: _)) -> h3
    | _ -> failwith "Not length 3"
end

(** 
   4. Now what if we want to pull the first, second, and third values of both 
   TupleTriple and ListTriple? Write a functor that will let us do this, and write
   some of your own tests/assertions. What are the two ways to declare functors?

   Answer: 
   Below are the 2 types of syntax we can use to create functors. They pull
   the first, second, and third values from our modules, and perform a unit test
   to assert that the first of a three element triple, (1,2,3), is 1. You can 
   write many more interesting and useful assertions than this too!
*)
module TestTriples (M : Triple) = struct
  let first_val = M.fst
  let sec_val = M.snd
  let thr_val = M.thr

  let unit_test = assert(M.(create 1 2 3 |> fst = 1))
end

module TestTriples = functor (M : Triple) -> struct
  let first_val = M.fst
  let sec_val = M.snd
  let thr_val = M.thr

  let unit_test = assert(M.(create 1 2 3 |> fst = 1))
end


