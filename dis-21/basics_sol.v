(** Church Encoding *)

Inductive nat : Type :=
| O : nat
| S : nat -> nat.

(** [succ n] is [n + 1]. *)
Definition succ (n: nat) : nat :=
  S n.

(** [pred n] is [n - 1] if [n > 0], or else [0]. *)
Definition pred (n: nat) : nat :=
  match n with
  | O    => O
  | S n' => n'
  end.


(** [even n] is [true] if [n] is even, or else [false]. *)
Fixpoint even (n: nat) : bool :=
  match n with
  | O        => true
  | S O      => false
  | S (S n') => even n'
  end.

(** Logic Theorems *)

Theorem implication : forall A B : Prop,
  A -> (A -> B) -> B.
Proof.
  intros A B a A_imp_B.
  apply A_imp_B in a.
  assumption.
Qed.

Theorem transitive : forall A B C : Prop,
  (A -> B) /\ (B -> C) -> (A -> C).
Proof.
  intros A B C A_imp_B_and_B_imp_C a.
  destruct A_imp_B_and_B_imp_C as [A_imp_B B_imp_C].
  apply A_imp_B in a.
  apply B_imp_C in a.
  assumption.
Qed .

Theorem disjunction_left : forall A B : Prop,
  A -> A \/ B.
Proof.
  intros A B a.
  left.
  assumption.
Qed. 

Theorem conjunction_left : forall A B : Prop,
  A /\ B -> A.
Proof.
  intros A B a_and_b.
  destruct a_and_b as [a b].
  assumption.
Qed.
