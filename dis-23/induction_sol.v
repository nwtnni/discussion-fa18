Theorem plus_n_0 : forall n : nat,
  n = n + 0.
Proof.
  induction n.
  - simpl. reflexivity.
  - simpl. rewrite <- IHn. reflexivity.
Qed.

Theorem plus_comm : forall n m : nat,
  n + m = m + n.
Proof.
  intros n m.
  induction n as [|n' IH].
  - trivial.
  - simpl. rewrite IH. trivial.
Qed.

Theorem plus_assoc : forall n m p : nat,
  n + (m + p) = (n + m) + p.
Proof.
  intros n m p.
  induction n.
  - trivial. 
  - simpl. rewrite IHn. reflexivity.
Qed.

Theorem plus_swap : forall n m p : nat,
  n + (m + p) = m + (n + p).
Proof.
  intros n m p.
  rewrite plus_assoc.
  replace (m + (n + p)) with (m + n + p). 
  - replace (n + m) with (m + n).
    * trivial.
    * apply plus_comm.
  - rewrite plus_assoc. trivial.
Qed.
