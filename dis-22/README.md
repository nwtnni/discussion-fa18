# Programs as Proofs

We recently learned that programs can be seen as proofs, and that by looking at our function types we can actually write propositions which we can prove using Coq.

The [3110 Coq cheatsheet][1] has a lot of great examples of different tactics we can use when solving proofs in Coq.

## Example: Curry

In this example, we look at the function
```ocaml
curry f x y = f (x, y);;
```
Putting this into utop, we see that the function's type is 
```ocaml
('a * 'b -> 'c) -> 'a -> 'b -> 'c
```

We can convert this into a proposition as follows:
```
(A /\ B => C) => A => B => C
```

Now we have a proof we can formalize and solve using Coq. We first start our theorem and the proposition we wish to prove. We do that by defining the proposition as above using keyword ```Prop``` and saying we wish to prove it for every value of A, B, and C using keyword ```forall```.

```coq
Theorem curry: (forall A B C : Prop, (A /\ B -> C) -> A-> B -> C).
```

Now, we can begin our proof. Note that our proposition has four parts:
1. A /\ B -> C
2. A
3. B
4. C
The inputs (or givens) of our proof are 1, 2, and 3, while 4 is our output (what we are trying to prove). When we write our proof, we need to introduce some variables. Let's use ```A```, ```B```, and ```C``` to describe the A, B, and C in our proposition. We also need to provide variable names for our inputs, 1, 2, and 3 above. You can think of this as evidence for this input; we are basically telling Coq that it can assume these are true. Let's call ```f``` our evidence for A /\ B -> C, ```a``` our evidence for A, and ```b``` our evidence for B. So far, we have:

```coq
Theorem curry: (forall A B C : Prop, (A /\ B -> C) -> A-> B -> C).
Proof.
  intros A B C f a b.
```

If you run your code up until this point, you should see something like:
```coq
A, B, C: Prop
f: A /\ B -> C
a: A
b: B
```
This is saying we have A, B, and C as variables (they are of type Prop), and that we have three givens, which are our inputs above. From here, the proof is actually complete. We can use A and B in A/\ B -> C to prove C. The entire proof is:

```coq
Theorem curry: (forall A B C : Prop, (A /\ B -> C) -> A -> B -> C).
Proof.  
  intros A B C f x y.
  auto.
Qed.
```

[1]: http://www.cs.cornell.edu/courses/cs3110/2018fa/lec/20-coq-fp/cheatsheet.html


