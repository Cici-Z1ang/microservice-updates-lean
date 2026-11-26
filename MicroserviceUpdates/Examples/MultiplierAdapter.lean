import MicroserviceUpdates.Compatibility

/-!
# AI-generated adapter synthesis/proof prototype

This is a **toy finite-search experiment**, not an example from the paper.
It instantiates the paper's forward-translation direction:

* the old worker adds `n` to the state;
* the updated worker adds `2*n`;
* a translation serviced atomically by an old worker repeats the request;
* a small enumerator searches candidate repetition counts using probes;
* Lean then proves the selected adapter correct for all natural-number states
  and requests, not merely for the probes.

The model intentionally uses the same request type and state space for both
versions, matching assumptions stated in §4.1.
-/

namespace MicroserviceUpdates.Examples.MultiplierAdapter

open MicroserviceUpdates

def oldService : AtomicService Nat Nat Nat where
  step state request :=
    let result := state + request
    (result, result)

def newService : AtomicService Nat Nat Nat where
  step state request :=
    let result := state + 2 * request
    (result, result)

/-- Candidate adapter: repeat a request `count` times on an old worker. -/
def candidateTranslation (count request : Nat) : List Nat :=
  List.replicate count request

def probeStates : List Nat := [0, 1, 7, 19]
def probeRequests : List Nat := [0, 1, 2, 5, 11]

/-- Executable bounded test used only to guide synthesis. It is not the proof. -/
def candidatePassesProbes (count : Nat) : Bool :=
  probeStates.all fun state =>
    probeRequests.all fun request =>
      decide (
        oldService.runAtomically state (candidateTranslation count request) =
        some (newService.step state request))

/-- The prototype enumerative synthesizer. -/
def synthesizeMultiplier : Option Nat :=
  [0, 1, 2, 3, 4].find? candidatePassesProbes

/-- Reproducible evidence for what the search returns. -/
theorem synthesis_result : synthesizeMultiplier = some 2 := by
  decide

/-- Use the enumerator's result as a partial translation. -/
def generatedTranslation : PartialTranslation Nat :=
  fun request => synthesizeMultiplier.map (fun count => candidateTranslation count request)

/-- A proof-carrying artifact suitable for a compatibility-aware update
controller in the simplified model. -/
def certifiedAdapter : CertifiedForwardAdapter oldService newService where
  translate request := candidateTranslation (synthesizeMultiplier.getD 0) request
  correct state request := by
    change oldService.runAtomically state
      (candidateTranslation (synthesizeMultiplier.getD 0) request) =
      some (newService.step state request)
    rw [synthesis_result]
    change some (state + request + request, state + request + request) =
      some (state + 2 * request, state + 2 * request)
    have h : state + request + request = state + 2 * request := by
      rw [Nat.two_mul, Nat.add_assoc]
    rw [h]

/-- The executable synthesis result satisfies the compatibility obligation for
every natural-number state and request. -/
theorem generatedTranslation_forwardCompatible :
    ForwardCompatible oldService newService generatedTranslation := by
  intro request state
  refine ⟨certifiedAdapter.translate request, ?_, certifiedAdapter.correct state request⟩
  change synthesizeMultiplier.map (fun count => candidateTranslation count request) =
    some (candidateTranslation (synthesizeMultiplier.getD 0) request)
  rw [synthesis_result]
  rfl

end MicroserviceUpdates.Examples.MultiplierAdapter

