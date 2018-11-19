Theorem plus_n_0 : forall n : nat,
  n = n + 0.
Admitted.

(* Hint: check out the [plus_n_Sm] theorem
 * in the Coq standard library's Peano module *)
Theorem plus_comm : forall n m : nat,
  n + m = m + n.
Proof.
Admitted.

Theorem plus_assoc : forall n m p : nat,
  n + (m + p) = (n + m) + p.
Proof.
Admitted.

(* Hint: no induction needed *)
Theorem plus_swap : forall n m p : nat,
  n + (m + p) = m + (n + p).
Proof.
Admitted.
