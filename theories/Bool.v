Require Forcing.

Section Bool.

Variable Obj : Type.
Variable Hom : Obj -> Obj -> Type.

Notation "P ≤ Q" := (forall R, Hom Q R -> Hom P R) (at level 70).
Notation "#" := (fun (R : Obj) (k : Hom _ R) => k).
Notation "f ∘ g" := (fun (R : Obj) (k : Hom _ R) => f R (g R k)) (at level 40).

Forcing Translate bool using Obj Hom.

Definition bool_rec : forall P, P -> P -> bool -> P :=
  fun P Ptt Pff b => match b with true => Ptt | false => Pff end.

Forcing Translate bool_rec using Obj Hom.

Definition bool_mem : forall R, bool -> (bool -> R) -> R :=
  fun R b => bool_rec ((bool -> R) -> R) (fun k => k true) (fun k => k false) b.

Forcing Translate bool_mem using Obj Hom.

Forcing Translate eq using Obj Hom.

Definition eta_eq : forall (b : bool), b = b :=
fun b => match b return b = b with true => eq_refl | false => eq_refl end.

Fail Forcing Translate eta_eq using Obj Hom.

Definition bool_rect : forall P,
  P true -> P false -> forall (b : bool), if b then P true else P false :=
fun P pt pf b =>
match b return
  match b with
  | true => P true
  | false => P false
  end
with
| true => pt
| false => pf
end.

Fail Forcing Translate bool_rect using Obj Hom.

Forcing Definition bool_rect' : forall P,
    P true -> P false -> forall (b : bool), bool_mem _ b P
                                                     using Obj Hom.
intros p P Htrue Hfalse b.
compute.
pose (P_type := fun p => forall p0 : Obj,
      p ≤ p0 ->
      (forall p : Obj, p0 ≤ p -> boolᶠ p) ->
      forall p : Obj, p0 ≤ p -> Type).
pose (Htrue_type := fun p (P:P_type p) => forall (p0 : Obj) (α : p ≤ p0),
          P p0 (# ∘ (α ∘ #)) (fun (p : Obj) (_ : p0 ≤ p) => trueᶠ p) p0 #).
pose (Hfalse_type := fun p (P:P_type p) => forall (p0 : Obj) (α : p ≤ p0),
          P p0 (# ∘ (α ∘ #)) (fun (p : Obj) (_ : p0 ≤ p) => falseᶠ p) p0 #).
pose (Goal_type := fun p (P:P_type p) (Htrue : Htrue_type p P) (Hfalse : Hfalse_type p P)
                       (b: boolᶠ p)
                   => match b with
   | trueᶠ _ =>
       fun
         k : forall p0 : Obj,
             p ≤ p0 ->
             (forall p1 : Obj, p0 ≤ p1 -> boolᶠ p1) ->
             forall p1 : Obj, p0 ≤ p1 -> Type =>
       k p # (fun (p0 : Obj) (_ : p ≤ p0) => trueᶠ p0)
   | falseᶠ _ =>
       fun
         k : forall p0 : Obj,
             p ≤ p0 ->
             (forall p1 : Obj, p0 ≤ p1 -> boolᶠ p1) ->
             forall p1 : Obj, p0 ≤ p1 -> Type =>
       k p # (fun (p0 : Obj) (_ : p ≤ p0) => falseᶠ p0)
   end
     (fun (p0 : Obj) (α : p ≤ p0) =>
      P p0 (fun (R : Obj) (k : Hom p0 R) => α R k)) p 
     #).
change (Goal_type p P Htrue Hfalse (b p #)).
set (b0 := b p #). 
exact ( match b0 as b1 return Goal_type _ _ _ _ b1 with
        | trueᶠ _ =>  Htrue p #
        | falseᶠ _ => Hfalse p #
end). 
Defined.


End Bool.
