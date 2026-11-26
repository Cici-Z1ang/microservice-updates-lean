import MicroserviceUpdates.PaperModel

/-!
# Abstract formalization of the paper's Theorem 6.13

The paper proves update consistency by repeatedly rewriting a computation in a
client-equivalent way while strictly decreasing the lexicographic pair from
Definition 6.12. The base case is reached when either component is zero, using
Theorem 6.9 or Theorem 6.11.

This file machine-checks that well-founded induction skeleton. It does **not**
yet prove that the concrete commutativity or compatibility rewrites of
Algorithms 2–5 meet these hypotheses.
-/

namespace MicroserviceUpdates

universe u v

/-- An explicit bundle of the hypotheses used by the abstract rewrite
induction. `sameEnd` is retained as a separate relation because the paper's
rewrite definition states it separately from client equivalence. -/
structure RewriteFramework (Client : Type u) (Comp : Type v) where
  atomic : Comp → Prop
  equivalentFor : Client → Comp → Comp → Prop
  sameEnd : Comp → Comp → Prop
  progress : Comp → Progress
  equivalentRefl : ∀ client comp, equivalentFor client comp comp
  equivalentTrans : ∀ client a b c,
    equivalentFor client a b → equivalentFor client b c → equivalentFor client a c
  sameEndRefl : ∀ comp, sameEnd comp comp
  sameEndTrans : ∀ a b c, sameEnd a b → sameEnd b c → sameEnd a c
  /-- Theorem 6.9 supplies the cut-progress-zero branch. -/
  atomicOfCutZero : ∀ comp, (progress comp).1 = 0 → atomic comp
  /-- Theorem 6.11 supplies the sort-progress-zero branch (for ordered updates
  in the paper; that premise is part of this abstract hypothesis). -/
  atomicOfSortZero : ∀ comp, (progress comp).2 = 0 → atomic comp
  /-- One client-specific rewrite step, corresponding to §6.3.1. -/
  rewrite : ∀ client comp,
    (progress comp).1 ≠ 0 →
    (progress comp).2 ≠ 0 →
    ∃ next,
      equivalentFor client comp next ∧
      sameEnd comp next ∧
      ProgressLt (progress next) (progress comp)

/-- Paper Theorem 6.13, at the level of its well-founded induction principle:
for each client, repeated valid rewrites reach an atomic, client-equivalent
computation with the same final state. -/
theorem rewrite_induction_reaches_atomic
    {Client : Type u} {Comp : Type v}
    (framework : RewriteFramework Client Comp)
    (client : Client) (initial : Comp) :
    ∃ atomicRun,
      framework.atomic atomicRun ∧
      framework.equivalentFor client initial atomicRun ∧
      framework.sameEnd initial atomicRun := by
  let motive : Progress → Prop := fun measure =>
    ∀ comp, framework.progress comp = measure →
      ∃ atomicRun,
        framework.atomic atomicRun ∧
        framework.equivalentFor client comp atomicRun ∧
        framework.sameEnd comp atomicRun
  apply (progressLt_wellFounded.induction (C := motive) (framework.progress initial))
  · intro measure smaller comp hMeasure
    by_cases hCut : (framework.progress comp).1 = 0
    · exact ⟨comp, framework.atomicOfCutZero comp hCut,
        framework.equivalentRefl client comp, framework.sameEndRefl comp⟩
    by_cases hSort : (framework.progress comp).2 = 0
    · exact ⟨comp, framework.atomicOfSortZero comp hSort,
        framework.equivalentRefl client comp, framework.sameEndRefl comp⟩
    obtain ⟨next, hEquivalent, hSameEnd, hDecrease⟩ :=
      framework.rewrite client comp hCut hSort
    have hSmaller : ProgressLt (framework.progress next) measure := by
      simpa [hMeasure] using hDecrease
    obtain ⟨atomicRun, hAtomic, hNextEquivalent, hNextEnd⟩ :=
      smaller (framework.progress next) hSmaller next rfl
    exact ⟨atomicRun, hAtomic,
      framework.equivalentTrans client comp next atomicRun hEquivalent hNextEquivalent,
      framework.sameEndTrans comp next atomicRun hSameEnd hNextEnd⟩
  · rfl

/-- Packaging the preceding result in Definition 4.1's `∀∃` form. -/
theorem rewrite_framework_update_consistent
    {Client : Type u} {Comp : Type v}
    (framework : RewriteFramework Client Comp)
    (initial : Comp) :
    UpdateConsistent framework.atomic framework.equivalentFor initial := by
  intro client
  obtain ⟨atomicRun, hAtomic, hEquivalent, _⟩ :=
    rewrite_induction_reaches_atomic framework client initial
  exact ⟨atomicRun, hAtomic, hEquivalent⟩

end MicroserviceUpdates

