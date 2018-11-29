# Intro to Formal Logic

We've seen some basic logic already in Coq (and as a result, in OCaml as well!). Let's formalize our understanding of logic a bit further.

Besides theorem proving, which we've used already, formal logic can help prove correctness of programs and allow us to formalize the reasoning of intelligent agents.

A logic is in itself just another programming language! It lets us express reasoning using evidence. Think of logic as using evidence to do reasoning, just as OCaml and other languages use data to do computations.

## Syntax
Let's formalize our logic syntax. This is our Intuitionistic Propositional Calculus:

```
f ::= P | f1 /\ f2 | f1 \/ f2 | f1 => f2 | ~f
```

| Symbol | Meaning                        |
|--------|--------------------------------|
| f      | Meta-variable for formulas     |
| P      | Meta-variable for propositions |
| /\     | AND                            |
| \\/     | OR                             |
| =>     | IMPLIES                        |
| ~      | NOT                            |

Using this syntax:
```
If it is not raining, it is sunny.
It is not raining.
Therefore, it is sunny.
```
This can be formalized as:
```
~R => S
~R
______
S
```

Or:
```
((~R => S) /\ (~R)) => S
```

## What's the point of this formal syntax?
The idea of Boolean logic is that all values are either true or false, and statements can be described using nothing more than the AND, OR, and NOT operators. Representing natural language statements in this formal syntax lets us use mathematical rules to prove theorems. 

For example:

```
CS students do their homework.
3110 students do their homework.
Therefore, 3110 students are CS students.
```

**Q** How would you write this formally? What's the problem with this argument?

**A** 

```
C -> H
S -> H
______
S -> C
```

Looking at the formal expressions, we can see this is actually a fallacy! This assumption does not hold!
We can use static semantics to tell when our argument is valid or invalid. This is called a proof system/deductive system.

## Evidence
In Coq theorems, we saw that we needed to provide evidence for propositions in our argument in order to prove them. What evidence would we need for:

1. A /\ B?
2. A \/ B?
3. A => B?

We'll use ```|- A``` as a way of saying "evidence for A".

**Introduction Rule:** how we can build a formula out of smaller pieces
```if |- A and |- B  then |- for A /\ B```

Conversely, what evidence can be assumed from a statement constitutes **Elimination Rules**

**Q** What information can we get from A /\ B? 
**A**

If |- A /\ B then |- A
If |- A /\ B then |- B

## Common logic rules:
Let's go through and convince ourselves of the following rules:

Modus Ponens
```
P => Q
P
_____
Q
```

Modus Tollens
```
A => B
~B
_____
~A
```
The following two are common logical fallacies, that do not actually hold!

Affirming the consequent:
```
A => B
B
_____
A
```

Denying the antecedent:
```
A => B
~A
_____
~B
```

## Notation for Assumptions
```F |- G ``` means that assuming F is provable, then G is provable.

Some rules/axioms:

| Rule name | Rule                                      |
|-----------|-------------------------------------------|
| /\ intro  | if F |- f1 and F |- f2 then F |- f1 /\ f2 |
| /\ elim L | if F |- f1 /\ f2 then F |- f1             |
| /\ elim R | if F |- f1 /\ f2 then F |- f2             |
| => elim   | if F |- f and F |- f => g then F |- g     |
| => intro  | if F, f |- g then F |- f => g             |
| assump    | f |- f                                    |
| weak      | if F |- f then F, g |- f                  |

**Example:** Using this notation, show ```|- (A => (B => A))```

1. ```A |- A``` by assumption rule
2. ```A, B |- A``` by (1) and weakening rule
3. ```A |- B => A``` by (2) and => introduction rule
4. ```|- A => (B => A)``` by (3) and => introduction rule

As a graphical representation (proof tree):
_______assump.
A |- A
__________weak.
A, B |- A
____________=> intro.
A |- B => A
___________________=> intro.
|- (A => (B => A))

As an OCaml program, we can write this as:
```ocaml
let t (a:'a) (b:'b) : 'a = a
```
Note the type!

**Q** Show ```|- A => (B => (A /\ B))``` and write the graphical representation. How would you write this in OCaml?

**A** 

1. A |- A by assump.
2. A, B |- by weak.
3. B |- B by assump.
4. A, B |- B by weak.
5. A, B |- A/\B by (2), (4), and /\ intro.
6. A |- B => (A/\B) by (5) and => intro.
7. |- A => (B => (A/\B)) by (6) and => intro.

_______assump           _______ assump
A |- A                  B |- B
_________weak           ___________weak
A, B |- A               A, B |- B
___________________________________ /\ intro.
    A, B |- A /\ B
___________________________________ => intro
    A |- B => (A /\ B)
___________________________________ => intro
    |- A => (B => (A /\ B))

OCaml:
```OCaml
let pair (a:'a) (b:'b) : ('a*'b) = (a,b)
```