Theorem curry: (forall A B C : Prop, (A /\ B -> C) -> A -> B -> C).
Proof.  
  intros A B C f x y.
  auto.
Qed.

Print curry.

Theorem decurry: (forall A B C: Prop, (A->B->C)->A/\B->C).
Proof.
  intros A B C f AandB.
  destruct AandB as [a b].
  auto.
Qed.

Theorem transitive: forall A B C: Prop,
  (A->B) /\ (B->C) -> (A->C).
Proof.
  intros A B C ABBC a.
  destruct ABBC as [AB BC].
  apply AB in a.
  apply BC in a.
  auto.
Qed.

Theorem disjunction: forall A B: Prop,
  A -> A \/ B.
Proof.
  intros A B a.
  left.
  auto.
Qed.





