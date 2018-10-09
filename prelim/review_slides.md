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
We didn't need to give a name to the internal function (```fun y -> x * y```) because we don't use it elsewhere.

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
### Maps
Apply a function to every element of a list



---
### Fold Left/Fold Right

---
### Functors

---
### Include vs. Open

---
### Streams

---
### Laziness

---
### Balanced Trees


---
### Sample Problems
From 3.34: is_bst exercise
Take from chapter 5: fractions, encapsulation, mapping

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