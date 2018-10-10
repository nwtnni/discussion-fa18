<!-- $theme: gaia -->
<!-- $size: 4:3 -->
<!-- page_number: true -->

# CS3110 Prelim Review

10/10/2018
 
---
### Anonymous Functions
Functions are values! Like other values (3, "sup", etc) we may not need to give them variable names.

For example:
```ocaml
# fun x -> x * x;;
```
takes in some value x, and returns its square. We can put it directly into another function. This can be helpful if we only need to use this anonymous function in that particular place.

---
For example, we can partially apply a function:

```ocaml
# let mul x = fun y -> x * y;; (* multiplies x and y *)

# let mul5 = mul 5;; (* multiplies 5 and y *)
```
We didn't need to give a name to the internal function (`fun y -> x * y`) because we don't use it elsewhere.

Now we can use the mul5 function to multiply anything by 5:
```ocaml
# mul5 4;; 
- : int = 20
```

---
### More About Partial Application

You can "fill in" just part of a function. For example, if you know certain variable values, you can plug those in while leaving the rest unchanged.

```ocaml
# let concat x y = x ^ y;;

# let name x = concat "my name is ";;

# name "Inigo Montoya";;
- : string = "my name is Inigo Montoya"

````
---
### Abstraction
In your code, you may notice that you are doing similar operations to different input types (i.e. adding ints or contatenating strings). Abstraction lets us pull out the structure of these operations so we're not effectively copy-pasting code. Instead, we modify this base structure for each operation.


We will show some examples of abstraction in the following slides with maps and folding.

---
### Records
An each-of type you define. For example:
```ocaml
type movie = {name:string; year:int; actor:string}

(* Defining a value: *)
let l = {name="Labyrinth"; year=1986; actor="David Bowie"}

(* Accessing elements: *)
let goblin_king = l.actor

(* Using pattern matching: *)
match l with
  | {name=n; year=y; actor=a} -> n
  
(* or, with syntactic sugar: *)
match l with
  | {name; year; actor} -> name
```

---
### Variants
A one-of type you define. For example:
```ocaml
type cities = NYC | Boston | Chicago | LA | Houston

let c:cities = NYC

(* Pattern matching: *)
let city_population = function
  | NYC -> 8.54
  | Boston -> 0.67
  | Chicago -> 2.71
  | LA -> 3.98
  | Seattle -> 0.70
```

---
### Higher-Order Functions
Since functions are values, we can pass functions into other functions!

```ocaml
(* Applies input function f twice *)
let twice f x = f (f x)

(* Doubles a value x *)
let double x = 2 * x

(* Quadruples a value x *)
let quad x = twice double x
```

Here, `quad` takes in `twice` as an input and `twice` takes in and `double` as an input.

---
### Maps
Apply a function to every element of a list

```ocaml
let rec map f = function
  |  [] -> []
  | h::t -> (f h)::(map f t)
  
(* Examples: *)
let add1 lst = map (fun x -> x+1) lst
let concat3110 = map (fun x -> x ^ "3110") lst
```

This also shows another use for anonymous functions! (i.e. `fun x -> x + 1`)

---
### Fold Left/Fold Right

Folding lets you apply some operation to all elements of a list to combine them (i.e. adding or concatenating all elements).

This can be done from left to right (List.fold_left) or right to left (List.fold_right)

For example:
```ocaml
(* let my_fun = List.fold_left op init *)
let sum = List.fold_left (+) 0
let concat = List.fold_right (^) ""
```

---
### Modules
Good for code modularity!

```ocaml
module ModName = struct
	(* definitions *)
end
```

---
### Signatures

Signatures can be used to control what the client sees. It describes the module type.
```ocaml
module type ModuleTypeName = sig 
  (* declarations *)
end

module ModName:ModuleTypeName = struct
  (* definitions *)
end
```
Now the client can only see the definitions in the signature, even if there are more definitions in the module not covered in the signature.

---
###### Module Example:
```ocaml
module type Stack = sig
  type 'a stack
  val empty    : 'a stack
  val is_empty : 'a stack -> bool
  val push     : 'a -> 'a stack -> 'a stack
  val peek     : 'a stack -> 'a
  val pop      : 'a stack -> 'a stack
end
module ListStack:Stack = struct
  let empty = []
  let is_empty s = (s = [])
  let push x s = x :: s
  let peek = function
    | [] -> failwith "Empty"
    | x::_ -> x
  let pop = function
    | [] -> failwith "Empty"
    | _::xs -> xs
end
```

---
### More examples
There are TONS of examples in the textbook! 
See chapters 5.8 - 5.12

http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/ex_queues.html

---
### Include vs. Open
Use `include` and `open` to make code from one module accessable in another.

Include: essentially the same as copy-pasting your code!

Open: Allows access to your "opened" module only within a limited scope and not any farther.


---
#### Include vs. Open example:

```ocaml
module LifeUniverseAndEverything = struct
   the_answer = 42
end

module type Stack = sig
  ...
end

module ListStack : Stack = struct
  include LifeUniverseAndEverything
  ...
end
```
We can now access `the_answer = 42` in our ListStack, but what if we used open instead of include?

---
### Functors
Let us apply functions to structures, for example:
```ocaml
module type mySig = sig
  val x : int
end

module IncX (M: mySig) = struct
  let x = M.x + 1
end
```

```ocaml
# module A = struct let x = 0 end;;
# A.x
- : int = 0
# module B = IncX(A);;
# B.x;;
- : int = 1
```

---
### Notes 
We didn't have time to get through everything in discussion! We'll answer some more of the questions you provided us through the Google form in the following slides.

---
#### Q: What is the difference between <> and != and when do I use each?

A: Let's use the = and == operators to make this simpler. 

The = operator checks structural equality, i.e. are the values on either side of the operator equivalent?
```ocaml
3 = 3 (* true *)
```
The <> operator checks structural inequality - it returns true when the values are not the same.

---

The == operator checks the physical equality, i.e. are the values on either side of the operator *the same value*. This checks if their memory locations are the same.
```ocaml
"hello" == "hello" (* false! *)
```
Similarly, the != operator checks physical inequality - it returns true when the two values are stored in different memory locations.


---
### Exam Topics
static semantics
dynamic semantics
[higher-order functions](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/hop/functions.html)
[polymorphic functions](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/data/polymorphic_variants.html)
pattern matching
[lists](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/data/lists.html)
[tail recursion](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/data/tail_recursion.html)
[records](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/data/records.html)
[association lists](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/data/assoc_list.html)
[variants](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/data/variants.html)
[JSON](https://www.tutorialspoint.com/json/json_syntax.htm)

--- 
[modules](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/structures.html)
[module types](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/signatures.html)
[abstract types](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/abstract_types.html)
[functors](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/functors.html)
[trees](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/ads/bst.html)
tree traversals
[queues](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/modules/ex_queues.html)
[specifications](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/abstract/specification.html)
[abstraction functions](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/abstract/af.html)
[representation invariants](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/abstract/ri.html)
