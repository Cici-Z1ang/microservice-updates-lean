# Paper-to-Lean map and fidelity status

## Exact paper definitions and results targeted

The quotations below are short identifiers/transcriptions from the public
author/arXiv version; the source links and hashes are in `SOURCES.md`.

| Paper item | Exact content used | Lean status |
|---|---|---|
| §3.3 client equivalence | Same global start state; equal `(client,message)` projections; if finite, same end state. | `ClientEquivalent` captures all three clauses after projection. The projection machinery itself is not yet modeled. |
| Definition 4.1 | An update computation `ρ` is consistent iff for every client `c` there exists an atomic-update computation `c`-equivalent to `ρ`. | Quantifier shape is exact in `UpdateConsistent`. Atomicity/equivalence remain parameterized in the rewrite theorem. |
| Theorem 4.2 | No algorithm simultaneously admits some mixed-mode computation, is consistent for every system, and is oblivious, provided `|M| ≥ 2`. | Extracted, not yet formalized. |
| Definition 6.8 | Cut progress = number of updated actions inside the global update cut. | Represented as first `Nat` component only; action/cut calculation pending. |
| Theorem 6.9 | Cut progress zero implies an atomic update. | An explicit hypothesis of `RewriteFramework`; concrete proof pending. |
| Definition 6.10 | Sort progress = sum, over every non-updated database action, of preceding updated database actions (the inversion count). | Represented as second `Nat` component only; calculation pending. |
| Theorem 6.11 | For an ordered update, sort progress zero implies an update-consistent cut. | An explicit base-case hypothesis; orderedness/cut proof pending. |
| Definition 6.12 | Progress is the lexicographic pair `(cut progress, sort progress)`, cut first. | Formalized as `Progress` and `ProgressLt`; well-foundedness is proved. |
| Theorem 6.13 | A client rewrite strategy for every client implies update consistency. | Its well-founded induction core is proved by `rewrite_framework_update_consistent`. Concrete rewrite validity is not. |
| Theorem 6.14 | Algorithm 2 guarantees a consistent update. | Not yet formalized. |
| §7.1.1 backwards translation | Partial `B : M → M*`; updated service of `B(r)` from `σ` has the same final global state and client projection as old service of `r`. | Executable in `BackwardCompatibleAt`, with a last-visible-response abstraction. |
| §7.1.1 forwards translation | Partial `F : M → M*`; old service of `F(r)` from `σ` has the same final global state and client projection as updated service of `r`. | Executable in `ForwardCompatibleAt`; instantiated and proved in the toy prototype. |
| Theorem 7.1 | Algorithms 3 and 4 guarantee a consistent update; proof additionally assumes the database is oblivious to worker identity. | Not yet formalized. |
| Theorem 7.2 | Algorithm 5 (commutativity plus forward compatibility) guarantees a consistent update. | Not yet formalized. |

## Assumptions extracted from the paper

- Clients are mutually independent and do not directly observe one another's
  request/response actions.
- Clients treat the service internals as a black box and do not know which
  worker serviced a request or the active worker set.
- Each client issues requests sequentially.
- Workers are isomorphic up to identities/internal-action renaming and share a
  database whose operations are atomic.
- Every serviced request includes a database operation, possibly a no-op.
- Updates change worker instruction/general local state, not channel state,
  channel structure, or message types; the paper excludes feature additions or
  removals that change the message set.
- Every worker updates exactly once; eventually all workers update; only one
  update is considered at a time.
- Updates are quiescent: a worker updates only while waiting for a request.
- Atomic quiescent updates are assumed to satisfy the service requirements.
- Compatibility rewriting additionally assumes the database is oblivious to
  the requesting worker's identity.
- Translation sequences are treated atomically.

## Status labels used in this repository

- **Paper-faithful statement/shape:** directly mapped to a numbered definition
  or theorem, but may abstract over structures not implemented yet.
- **Machine-checked contribution:** new Lean proof checked by the pinned kernel.
- **Toy prototype:** simplified executable service used to test feasibility;
  it is not evidence that the full algorithm theorem has been formalized.
- **Pending/unproved:** no Lean theorem is claimed.

