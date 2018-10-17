(** Mutable Singly-Linked Lists *)

(** Let's create a type for a mutable singly-linked list, such that the elements
    of the list are mutable. Notice that in this implementation, an mlist
    contains cells, which are a mutable value and a tail of type mlist.

    Note that this implementation has mutable elements, but the list is not
    mutable itself. As a challenge, make the list itself mutable once you've 
    finished this exercise!
*)

type mlist = Nil | Cons of cell
and cell = {mutable hd : int; tl : mlist}

(** How would you initialize such a list? Make a function new_cell below
    with just one element of the value 0 *)



(** Here, implement a function that will add another element of value v
    to the mutable list. It is a relatively simple function if you add the element
    to the head of the list. *)




(** Let's make an increment function that will add 1 to every term of
    our mutable list.  *)




(** Either here or in utop, check that this works. Try making a mutable list
    using new_cell as the base list, using add_element to add more values to the
    list, and using inc to increment all of the values. 

    Here is what I put into utop and the resulting outputs:

    # let x = Cons new_cell;;
    val x : mlist = Cons {hd = 0; tl = Nil}

    # let y = add_element x 1;;
    val y : mlist = Cons {hd = 1; tl = Cons {hd = 0; tl = Nil}}

    # inc y;;
    - : mlist = Nil

    # y;;
    - : mlist = Cons {hd = 2; tl = Cons{hd = 1; tl = Nil}}
*)


(** If you've finished, feel free to implement more functions of your choice!
    For example, you could:
    1) pull the nth element from a list 
    2) add two mutable lists (assume they're the same length)
    3) add all elements of a list
    4) use the abstraction principle to generalize 2) and 3) to any operation
*)
