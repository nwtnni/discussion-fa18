(** Discussion 6 Exercises *)
(** @author Noam Eshed ne236 *)

(*  map, filter *)
(* Below is a set of functions to help you practice higher-order 
   programming. These should not be long (1-5 lines each!). Test yourself and 
   refrain from looking at the online textbook for hints. *)

(* Implement the function rev_list WITHOUT using fold. It should take in 
   type 'a list and return 'a list with all elements in reversed order *)
let rec rev_list = function
  | _ -> failwith "unimplimented"

(* Implement a function that takes in type list list and reverses 
   the outer list and elements within the inner lists.
   Example:
   rev_all [[1;2;3];[4;5;6];[7;8;9;0]] -> [[0;9;8;7];[6;5;4];[3;2;1]]*)
(* Hint: use rev_list which you just implemented! *)
let rec rev_all = function
  | _ -> failwith "unimplimented"

(* Implement the function rev_fold using fold *)
let rev_fold lst = failwith "unimplimented"

(* Implement the function is_pal to check if a list is a palindrome *)
(* Hint: a palindrome is a list whose elements are the same forward and 
   backward, such as [1;2;3;2;1]*)
let is_pal lst = failwith "unimplimented"

(* Implement len_list, which returns the length of an 'a list *)
let len_list lst = failwith "unimplimented"

(* Implement the function map - without looking at the book notes! Recall that
   map takes in a function and applies it to each element of a list *)
let rec map f = failwith "unimplimented"

(* Implement the filter function to pull out any elements of a list meeting a
   certain criteria (such as pulling out all even or all odd elements *)
(* Hint: implement some helper functions such as even and odd *)
let rec filter f =  failwith "unimplimented"



(* Implement a binary tree type such that the type is 'a tree with leaves and 
   nodes. Each node should have exactly two sub-trees.*)


(* How is this similar to a list type? Define a list here *)


(* Implement the foldtree function to go through the elements of the tree. Note 
   that unlike the list, each node in a tree has a value, a left child, and a
   right child *)
let rec foldtree init op = failwith "unimplimented"

(* What operations would you like to be able to run on a tree? Brainstorm 2-3 
   and write them here: *)


(* If you are done, be creative and come up with some more higher-order 
   functions of your own below! *)