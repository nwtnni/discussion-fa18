(** 
   Recitation 12 - Streams

   We've provided you with the definition of a stream as written
   in lecture. Take a few minutes to review this code with your group
   and ask the TAs questions!

*)

(** This is the definition of a stream. It represents an infinite list of 
    type 'a *)
type 'a stream = 
  | Cons of 'a * (unit -> 'a stream)

(** from creates a stream having the first element int n and each following
    element increases by 1 *)
let rec from n =
  Cons (n, (fun () -> from (n+1)))

(** The list of natural numbers; <0,1,2,3,...> *)
let nats = from 0

(** returns the first element of a stream *)
let hd (Cons (h , _)) = h

(** returns the tail of the stream (all but the first element) *)
let tl (Cons (_, t)) = t ()

(** There are some exercises below to help you get the hang of streams.
    Go through them with your partner/team. *)

(** Write a function to add the elements of two streams such that for
    input streams <a1, a2, a3,...> and B<b1, b2, b3,...>* the output
    stream is <a1+b1, a2+b2, a3+b3,...> *)
let rec sum (Cons (ha, ta)) (Cons (hb, tb)) = 
  Cons (ha+hb, fun () -> sum (ta ()) (tb ()))

(** Write a function to return a list of the first n elements of a stream s *)
let rec take n s = 
  if n = 0 then []
  else (hd s) :: take (n-1) (tl s)

(** Write a function to return the nth element of a stream s *)
let rec get n s =
  if n = 0 then hd s
  else get (n-1) (tl s)

(** Write a function that will square every element of a stream*)
let rec square (Cons (h, t)) =
  Cons (h*h, fun () -> square (t ()))

(** Define an int stream whose values are the Fibbonacci sequence *)
let rec fibb =
  Cons(1, fun () ->
      Cons(1, fun () ->
          sum (tl fibb) fibb))