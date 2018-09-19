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
  (*Your code here*)
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
*)

(* Your code here *)


(** 
   3. Copy and paste TupleTripleExt below, rename it to TupleTripleOpen, and 
   change "include" to "open". What happens? Why is that?
*)

(* Your code here *)



(**
   Now, let's look at functors. We've created a new type of Triple, this time
   based on Lists. Discuss it with your partner to make sure you understand
   what it is doing. Why can we use the same signature as before (Triple) on 
   our new module?
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
*)

(* Your code here *)


