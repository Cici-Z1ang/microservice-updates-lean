# Experiment log

All dates are America/New_York.

## 2026-11-25 — source verification

- Independently confirmed title, authors, arXiv `2508.04829`, POPL 2026
  publication, volume/article metadata, and DOI `10.1145/3776700` using arXiv,
  the author-hosted PDF, Thomas Wies’s research page, and the ACM DOI metadata
  surfaced by the paper.
- Downloaded arXiv v2 PDF/source and the author-hosted publication PDF; recorded
  SHA-256 hashes in `SOURCES.md`.
- Inspected the arXiv source archive. It contains LaTeX and figures, including
  appendix proofs, but no mechanized artifact.
- Performed a bounded search for existing Lean/Coq/Isabelle formalizations; no
  relevant repository or supplementary code was found.

## 2026-11-25 — first formalization pass

- Pinned Lean 4.19.0 with no third-party dependencies.
- Added the client-equivalence/update-consistency quantifier shapes and the
  lexicographic progress order.
- Formalized the well-founded rewrite induction behind Theorem 6.13. This is
  an AI-generated formal proof of the abstract induction step, not a full proof
  that Algorithms 2–5 satisfy the rewrite hypotheses.
- Added executable forward/backward compatibility predicates following §7.1.1.
- Added an enumerative adapter experiment. Search probes identify repetition
  count 2; a separate theorem proves the generated adapter for all natural
  states and requests.

## 2026-11-25 — prepublication verification

- A clean build reproduced the first pass. Review found the demonstration's
  certified adapter duplicated the search result as a literal. The translation
  and certificate now refer directly to the enumerator, and the compatibility
  theorem checks that executable translation.
- The verification script now fails if an audited declaration uses any axiom
  or if its audit output is missing. The placeholder check includes the main
  executable, build configuration, and library entry point.

## Verification evidence

Run `scripts/verify.sh`. It writes:

- `build.log`: the complete Lake build result;
- `audit.log`: `#print axioms` results for all claimed theorems/artifacts;
- `demo.log`: the executable synthesis/adapter demonstration.

The script also rejects `sorry` and `admit` in project source.

Latest local result: the build passed; every audited declaration reported
“does not depend on any axioms”; the placeholder scan passed; and the demo
returned candidate count `some 2`, with both executions producing `(17, 17)`
for state `3` and request `7`.

## Current blockers / research risk

1. The paper's po-computation definition quantifies over all linearizations and
   demands each be a valid LTS computation. Choosing a Lean representation that
   makes swapping transactions tractable without weakening this condition is
   the main modeling decision.
2. Theorem 6.14’s cycle-freedom argument is a long architecture-specific case
   analysis. It cannot be honestly replaced by generic sorting alone.
3. The paper states compatibility in terms of client projections of an atomic
   translated sequence. A production adapter interface must specify precisely
   which intermediate requests/responses the update manager hides.
4. Theorem 7.1 introduces a fresh worker in its rewrite and relies on clients
   not knowing the active worker set plus database worker-identity obliviousness.
   Both assumptions need explicit Lean interfaces.
5. Real generative synthesis needs a service-specification language. The
   current enumerator searches only a tiny repetition-count grammar; the proof
   certificate is real, but the search space is intentionally toy-sized.

