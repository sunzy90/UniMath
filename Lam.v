Require Import UniMath.Foundations.Generalities.uu0.
Require Import UniMath.Foundations.hlevel1.hProp.
Require Import UniMath.Foundations.hlevel2.hSet.

Require Import UniMath.RezkCompletion.precategories.
Require Import UniMath.RezkCompletion.functors_transformations.
Require Import SubstSystems.UnicodeNotations.
Require Import UniMath.RezkCompletion.whiskering.
Require Import UniMath.RezkCompletion.Monads.
Require Import UniMath.RezkCompletion.limits.products.
Require Import UniMath.RezkCompletion.limits.coproducts.
Require Import UniMath.RezkCompletion.limits.terminal.
Require Import SubstSystems.Auxiliary.
Require Import SubstSystems.PointedFunctors.
Require Import SubstSystems.ProductPrecategory.
Require Import SubstSystems.HorizontalComposition.
Require Import SubstSystems.PointedFunctorsComposition.
Require Import SubstSystems.Signatures.
Require Import SubstSystems.SubstitutionSystems.
Require Import SubstSystems.FunctorsPointwiseCoproduct.
Require Import SubstSystems.FunctorsPointwiseProduct.

Local Notation "# F" := (functor_on_morphisms F)(at level 3).
Local Notation "F ⟶ G" := (nat_trans F G) (at level 39).
Arguments functor_composite {_ _ _} _ _ .
Arguments nat_trans_comp {_ _ _ _ _} _ _ .
Local Notation "G ∙ F" := (functor_composite F G : [ _ , _ , _ ]) (at level 35).
Local Notation "α ∙∙ β" := (hor_comp β α) (at level 20).
Ltac pathvia b := (apply (@pathscomp0 _ _ b _ )).

Local Notation "α 'ø' Z" := (pre_whisker Z α)  (at level 25).
Local Notation "Z ∘ α" := (post_whisker _ _ _ _ α Z) (at level 35).

Arguments θ_source {_ _} _ .
Arguments θ_target {_ _} _ .
Arguments θ_Strength1 {_ _ _} _ .
Arguments θ_Strength2 {_ _ _} _ .

Section Preparations.

Variable C : precategory.
Variable hs : has_homsets C.
Variable CP : Products C.

Definition square_functor:= product_functor C C CP (functor_identity C) (functor_identity C).

End Preparations.


Section Lambda.

Variable C : precategory.
Variable hs : has_homsets C.

(** The category of endofunctors on [C] *)
Local Notation "'EndC'":= ([C, C, hs]) .

Variable terminal : Terminal C.

Variable CC : Coproducts C.
Variable CP : Products C.

Let one : C :=  @TerminalObject C terminal.

(** 
   [App_H (X) (A) :=  X(A) × X(A)]
*)
Definition App_H : functor [C, C, hs] [C, C, hs].
Proof.
  apply square_functor.
  apply Products_functor_precat.
  exact CP.
Defined.

(*
Definition Lam_H : functor [C, C, hs] [C, C, hs]. *)
(** 
   [Lam_H (X) := X o option

   implement the functor (E + _) for fixed E

   needs terminal object

*)
(*
Definition Flat_H : functor [C, C, hs] [C, C, hs].*)
(** 
   [Flat_H (X) := X o X]
   
   ingredients:
     - functor_composite in RezkCompletion.functors_transformations 
     - map given by horizontal composition in Substsystems.HorizontalComposition
     - functor laws for this thing : 
         functor_id, functor_comp
         id_left, id_right, assoc

 Alternatively : free in two arguments, then precomposed with diagonal
 
*)



(** here definition of suitable θ's together with their strength laws  *)


Definition App_θ_data: ∀ XZ, (θ_source App_H)XZ ⇒ (θ_target App_H)XZ.
Proof.
  intro XZ.
  apply nat_trans_id.
Defined.

Lemma is_nat_trans_App_θ_data: is_nat_trans _ _ App_θ_data.
Proof.
  red.
  unfold App_θ_data.
  intros XZ XZ' αβ.
  destruct XZ as [X Z].
  destruct XZ' as [X' Z'].
  destruct αβ as [α β].
  simpl in *.
  apply nat_trans_eq; try assumption.
  intro c.
  simpl.
  rewrite id_left.
  rewrite id_right.
  unfold product_nat_trans_data, product_functor_mor.
  unfold ProductOfArrows.
  eapply pathscomp0.
  apply precompWithProductArrow.
  simpl.
  unfold product_nat_trans_pr1_data. unfold product_nat_trans_pr2_data.
  simpl.
  apply ProductArrowUnique.
  + rewrite ProductPr1Commutes.
    repeat rewrite assoc.
    rewrite ProductPr1Commutes.
    apply idpath.
  + rewrite ProductPr2Commutes.
    repeat rewrite assoc.
    rewrite ProductPr2Commutes.
    apply idpath.
Qed.

Definition App_θ: nat_trans (θ_source App_H) (θ_target App_H) :=
  tpair _ _ is_nat_trans_App_θ_data.

Lemma App_θ_strenght1_int: θ_Strength1_int _  _ _ App_θ.
Proof.
  red.
  intro.
  unfold App_θ, App_H.  
  simpl.
  unfold App_θ_data. 
  apply nat_trans_eq; try assumption.
  intro c.
  simpl.
  rewrite id_left.
  unfold product_nat_trans_data.
  apply pathsinv0.
  apply ProductArrowUnique.
  + rewrite id_left.
    unfold EndofunctorsMonoidal.λ_functor.
    unfold EndofunctorsMonoidal.ρ_functor.
    simpl.    
    rewrite id_right.
    apply idpath.
  + rewrite id_left.
    unfold EndofunctorsMonoidal.λ_functor.
    unfold EndofunctorsMonoidal.ρ_functor.
    simpl.    
    rewrite id_right.
    apply idpath.
Qed.


Lemma App_θ_strenght2_int: θ_Strength2_int _  _ _ App_θ.
Proof.
  red.
  intros.
  unfold App_θ, App_H.  
  simpl.
  unfold App_θ_data. 
  apply nat_trans_eq; try assumption.
  intro c.
  simpl.
  do 3 rewrite id_left.
  unfold product_nat_trans_data.
  apply pathsinv0.
  apply ProductArrowUnique.
  + rewrite id_left.
    unfold EndofunctorsMonoidal.α_functor.
    simpl.    
    rewrite id_right.
    apply idpath.
  + rewrite id_left.
    unfold EndofunctorsMonoidal.α_functor.
    simpl.    
    rewrite id_right.
    apply idpath.
Qed.




(** finally, constitute the 3 signatures *)

Definition App_Sig: Signature C hs.
Proof.
  exists App_H.
  exists App_θ.
  split.
  + exact App_θ_strenght1_int.      
  + exact App_θ_strenght2_int.
Defined.


End Lambda.
