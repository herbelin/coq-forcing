Require Import Forcing.

Axiom Obj : Type.
Axiom Hom : Obj -> Obj -> Type.

Notation "P ≤ Q" := (forall R, Hom Q R -> Hom P R) (at level 70).
Notation "#" := (fun (R : Obj) (k : Hom _ R) => k).
Notation "f ∘ g" := (fun (R : Obj) (k : Hom _ R) => f R (g R k)) (at level 40).

Definition foo := fun A (x : A) => x.
Definition qux := (fun (A : Type) (x : A) => x) Type (forall A : Type, A -> A).
Definition quz := Type -> Type.
Definition eq := fun (A : Type) (x y : A) => forall (P : A -> Prop), P x -> P y.

Forcing Translate foo using Obj Hom.
(* Forcing Translate qux using Obj Hom. *)
(* Forcing Translate quz using Obj Hom. *)
(* Forcing Translate eq using Obj Hom. *)

