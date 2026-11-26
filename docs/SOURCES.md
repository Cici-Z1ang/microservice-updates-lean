# Sources and artifact search

Checked on 2026-11-25 (America/New_York).

## Primary paper

- Devora Chait-Roth, Kedar S. Namjoshi, Thomas Wies, “Consistent Updates for
  Scalable Microservices,” *Proc. ACM Program. Lang.* 10 (POPL), Article 58,
  2026, pp. 1673–1701. DOI: <https://doi.org/10.1145/3776700>.
- arXiv: <https://arxiv.org/abs/2508.04829> (v1 posted 2025-08-06; public v2
  source downloaded for this experiment).
- Author-hosted paper:
  <https://cs.nyu.edu/~wies/publ/popl26_consistent_updates.pdf>.
- Thomas Wies’s research page lists this paper under “Consistent Microservice
  Updates”: <https://cs.nyu.edu/~wies/>.

Downloaded reference hashes (kept outside the deliverable repository under
the experiment workspace’s `work/sources/`):

```text
arXiv v2 PDF  sha256 dc879eaf392d0a8e386d255605597c6a08373b81a082625a486f8e5ff4990b2d
arXiv v2 src  sha256 f10f2b652146083bae234725a82cd4decb83787dbf0db085aa1abfe6e7b71d11
author PDF    sha256 5931e220b97e24ade51bba932a3bfebfc72e324a926f6c82c377a15d3c72b857
```

The arXiv source contains the appendix proofs referenced as supplementary
material. Its top-level files include `appendix.tex`, `background.tex`,
`consistent-updates.tex`, `update-algorithms.tex`, and
`update-po-proofs.tex`; no code or proof-assistant artifact is included.

## Existing-formalization search

Public web/GitHub searches were run for the exact title, arXiv identifier,
“Theorem 6.13” plus update-consistency terms, “cut progress measure,” and title
plus Lean/Coq/Isabelle. The author page and arXiv source were inspected. No
existing proof-assistant formalization or implementation artifact was found.

This is a bounded negative search result, not a proof that no private or
unindexed formalization exists.

## Toolchain

- Lean 4.19.0, commit `6caaee842e94`
- Lake 5.0.0 from that Lean distribution
- No Mathlib or other Lean package dependency

