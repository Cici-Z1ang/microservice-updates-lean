/-!
# Compatibility translations from §7.1.1

The paper uses partial translations `B, F : M → M*`. A translated request may
become a sequence, serviced atomically. Compatibility requires the translated
and untranslated executions to have the same final global state and the same
client projection.

This executable model represents the client projection by the last visible
response and hides intermediate responses inside an atomic batch. It captures
the equality obligation but not concurrency, workers, routing, or database
identity-obliviousness. Consequently it supports adapter certificates, not yet
Theorem 7.1 for the full microservice model.
-/

namespace MicroserviceUpdates

universe u v w

/-- A deterministic, atomic request semantics for the adapter prototype. -/
structure AtomicService (State : Type u) (Request : Type v) (View : Type w) where
  step : State → Request → State × View

namespace AtomicService

/-- Run a nonempty translated sequence atomically, exposing only its final
response to the client. Empty translations have no client response. -/
def runAtomically
    {State : Type u} {Request : Type v} {View : Type w}
    (service : AtomicService State Request View) :
    State → List Request → Option (State × View)
  | _, [] => none
  | state, [request] => some (service.step state request)
  | state, request :: next :: rest =>
      runAtomically service (service.step state request).1 (next :: rest)

end AtomicService

/-- A paper-style partial request-to-sequence translation. -/
abbrev PartialTranslation (Request : Type v) := Request → Option (List Request)

/-- §7.1.1 backward compatibility, for one request. -/
def BackwardCompatibleAt
    {State : Type u} {Request : Type v} {View : Type w}
    (oldService newService : AtomicService State Request View)
    (translate : PartialTranslation Request)
    (request : Request) : Prop :=
  ∀ state, ∃ translated,
    translate request = some translated ∧
    newService.runAtomically state translated = some (oldService.step state request)

/-- §7.1.1 forward compatibility, for one request. -/
def ForwardCompatibleAt
    {State : Type u} {Request : Type v} {View : Type w}
    (oldService newService : AtomicService State Request View)
    (translate : PartialTranslation Request)
    (request : Request) : Prop :=
  ∀ state, ∃ translated,
    translate request = some translated ∧
    oldService.runAtomically state translated = some (newService.step state request)

def ForwardCompatible
    {State : Type u} {Request : Type v} {View : Type w}
    (oldService newService : AtomicService State Request View)
    (translate : PartialTranslation Request) : Prop :=
  ∀ request, ForwardCompatibleAt oldService newService translate request

/-- A forward adapter whose §7.1.1 equality obligation is carried as a Lean
proof. The list is total here; partial translations remain available above. -/
structure CertifiedForwardAdapter
    {State : Type u} {Request : Type v} {View : Type w}
    (oldService newService : AtomicService State Request View) where
  translate : Request → List Request
  correct : ∀ state request,
    oldService.runAtomically state (translate request) =
      some (newService.step state request)

end MicroserviceUpdates

