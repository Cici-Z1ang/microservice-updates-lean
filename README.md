# Consistent microservice updates — Lean feasibility prototype

This repository contains an AI-assisted Lean experiment based on Chait-Roth,
Namjoshi, and Wies's [*Consistent Updates for Scalable Microservices*](https://arxiv.org/abs/2508.04829).

Status: **initial verified prototype, not a complete paper formalization**.

## What is machine-checked

1. `RewriteInduction.lean` formalizes the well-founded induction skeleton of
   paper Theorem 6.13 over the exact lexicographic shape of Definition 6.12.
   It proves that the stated rewrite obligations imply a client-equivalent
   atomic computation and packages the result in Definition 4.1's `∀∃` form.
2. `Compatibility.lean` gives executable versions of the partial translations
   and final-state/client-view equality obligation from §7.1.1.
3. `MultiplierAdapter.lean` runs a bounded enumerative synthesis experiment.
   The certified adapter uses the search result and carries a Lean proof for
   all natural-number states and requests in the simplified model.

## What is not yet machine-checked

The paper's full communicating LTS, relays, quiescent updates, update shells,
happens-before construction, consistent cuts, and the concrete correctness of
Algorithms 2–5 are not formalized yet. In particular, this repository does not
claim Theorem 6.14, Theorem 7.1, or Theorem 7.2 for the paper's full model.

## Reproduce

The project pins Lean 4.19.0 and has no external Lean dependencies.

```sh
bash scripts/verify.sh
```

This builds every module, requires the audited declarations to have zero axiom
dependencies, runs the adapter demo, and rejects `sorry`/`admit` placeholders.

See `docs/PAPER_MAP.md`, `docs/SOURCES.md`, and `docs/EXPERIMENT_LOG.md` for
fidelity boundaries, provenance, and an execution record.

