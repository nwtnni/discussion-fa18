(** Church Encoding *)

Inductive nat : Type :=
| O : nat
| S : nat -> nat.

(** [succ n] is [n + 1]. *)
Definition succ (n: nat) : nat
  (* TODO: replace this line *). Admitted.

(** [pred n] is [n - 1] if [n > 0], or else [0]. *)
Definition pred (n: nat) : nat
  (* TODO: replace this line *). Admitted.

(** [even n] is [true] if [n] is even, or else [false]. *)
Fixpoint even (n: nat) : bool
  (* TODO: replace this line *). Admitted.

(** Logic Theorems *)

Theorem implication : forall A B : Prop,
  A -> (A -> B) -> B.
Proof.
  (* TODO: replace with proof and then Qed.*)
Admitted.

Theorem transitive : forall A B C : Prop,
  (A -> B) /\ (B -> C) -> (A -> C).
Proof.
  (* TODO: replace with proof and then Qed.*)
Admitted.

Theorem disjunction_left : forall A B : Prop,
  A -> A \/ B.
Proof.
  (* TODO: replace with proof and then Qed.*)
Admitted.

Theorem conjunction_left : forall A B : Prop,
  A /\ B -> A.
Proof.
  (* TODO: replace with proof and then Qed.*)
Admitted.
