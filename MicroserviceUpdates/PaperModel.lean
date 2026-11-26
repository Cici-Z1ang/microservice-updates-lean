/-!
# Core vocabulary from the POPL 2026 paper

This module records a deliberately small semantic interface for the first
formalization pass. It is paper-grounded, but it is not yet the paper's full
communicating-LTS model.

Paper mapping:

* `ClientEquivalent` reflects the three clauses in §3.3: same start state,
  same client/message projection, and (for the finite computations modeled
  here) same end state.
* `UpdateConsistent` is Definition 4.1's `∀ client, ∃ atomic equivalent` shape.
* `Progress` and `ProgressLt` reflect Definition 6.12's lexicographic pair of
  cut progress and sort progress.

The full relay, channel, worker, database, happens-before, and quiescence
structure remains future work. The abstract fields below must not be read as a
proof of Algorithms 2–5.
-/

namespace MicroserviceUpdates

universe u v

/-- A finite observation of an update computation at the abstraction boundary
used by the initial metatheory formalization. -/
structure Computation (GlobalState : Type u) (ClientView : Type v) where
  startState : GlobalState
  endState : GlobalState
  /-- The already-projected request/response messages visible to one client. -/
  clientView : ClientView

/-- §3.3, specialized to finite computations whose client/message projection
has already been computed. -/
def ClientEquivalent
    {GlobalState : Type u} {ClientView : Type v}
    (left right : Computation GlobalState ClientView) : Prop :=
  left.startState = right.startState ∧
  left.clientView = right.clientView ∧
  left.endState = right.endState

/-- Definition 4.1's quantifier structure. `Atomic` is intentionally a
parameter until the full LTS and update-action model is implemented. -/
def UpdateConsistent
    {Client : Type u} {Comp : Type v}
    (Atomic : Comp → Prop)
    (EquivalentFor : Client → Comp → Comp → Prop)
    (actual : Comp) : Prop :=
  ∀ client, ∃ atomicRun, Atomic atomicRun ∧ EquivalentFor client actual atomicRun

/-- Definition 6.12: cut progress first, sort progress second. -/
abbrev Progress := Nat × Nat

/-- Lexicographic comparison used by Definition 6.12. -/
abbrev ProgressLt : Progress → Progress → Prop :=
  Prod.Lex Nat.lt Nat.lt

/-- The paper's progress order is well-founded. -/
theorem progressLt_wellFounded : WellFounded ProgressLt :=
  (Prod.lex Nat.lt_wfRel Nat.lt_wfRel).wf

end MicroserviceUpdates

