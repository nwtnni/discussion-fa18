# Inductive Proofs

Today we'll be proving the following basic facts about integers,
which are an inductive type. These theorems are taken from
[Logical Foundations][1], which is an excellent resource for
more Coq practice.

```coq
Theorem plus_n_0 : forall n : nat,
  n = n + 0.

Theorem plus_comm : forall n m : nat,
  n + m = m + n.

Theorem plus_assoc : forall n m p : nat,
  n + (m + p) = (n + m) + p.

Theorem plus_swap : forall n m p : nat,
  n + (m + p) = m + (n + p).
```

[1]: https://softwarefoundations.cis.upenn.edu/lf-current/index.html
