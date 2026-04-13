---
type: reading-queue
title: Reading Queue
updated: 2026-04-13
---

# Reading Queue

Persistent backlog of candidate next ingests surfaced from prior ingests. Each entry links back to the source page that surfaced it, and is annotated with a one-line "why it matters" that anchors the suggestion in what we already know.

Append-only in spirit: move entries between sections rather than deleting. `hot.md`'s "Open Questions" section draws its top picks from this file.

## Queued

### Precursors to the Transformer (from Vaswani 2017 bibliography)

- [ ] **Bahdanau, Cho, Bengio 2014 — Neural Machine Translation by Jointly Learning to Align and Translate** ([arXiv:1409.0473](https://arxiv.org/abs/1409.0473))
  - **Why:** The original attention mechanism. Vaswani 2017 positions itself as "attention without RNNs" — understanding Bahdanau attention first makes it clear why "dispensing with recurrence entirely" was the bold claim, not just the mechanics of attention itself. Additive attention is the foil to [[scaled-dot-product-attention]].
  - Surfaced from: [[summary-attention-is-all-you-need]]

- [ ] **Sutskever, Vinyals, Le 2014 — Sequence to Sequence Learning with Neural Networks** ([arXiv:1409.3215](https://arxiv.org/abs/1409.3215))
  - **Why:** The foundational encoder-decoder paper that established the seq2seq framing the Transformer inherits. Defines the vocabulary ("encoder", "decoder", auto-regressive generation) that every subsequent paper assumes.
  - Surfaced from: [[summary-attention-is-all-you-need]]

- [ ] **Luong, Pham, Manning 2015 — Effective Approaches to Attention-based Neural Machine Translation** ([arXiv:1508.04025](https://arxiv.org/abs/1508.04025))
  - **Why:** Introduces dot-product attention as a faster alternative to Bahdanau's additive form. Direct precursor to [[scaled-dot-product-attention]] — Vaswani 2017's √d_k scaling is a small correction applied to this formulation.
  - Surfaced from: [[summary-attention-is-all-you-need]]

### Transformer companions (from Vaswani 2017 bibliography)

- [ ] **Ba, Kiros, Hinton 2016 — Layer Normalization** ([arXiv:1607.06450](https://arxiv.org/abs/1607.06450))
  - **Why:** The normalization the Transformer wraps every sub-layer with. Understanding why LayerNorm (vs BatchNorm) and why it's applied here clarifies a lot of later architectural decisions — pre-LN vs post-LN debates, RMSNorm, and training stability issues in scaled transformers.
  - Surfaced from: [[summary-attention-is-all-you-need]]

- [ ] **Shazeer et al. 2017 — Outrageously Large Neural Networks: The Sparsely-Gated Mixture-of-Experts Layer** ([arXiv:1701.06538](https://arxiv.org/abs/1701.06538))
  - **Why:** [[noam-shazeer|Noam Shazeer]]'s prior work on conditional computation. Precursor to Switch Transformer, GLaM, and Mixtral. Good second exposure to Shazeer's design style (he's credited with three of the Transformer's key innovations too). Also a strong cross-reference for future MoE papers.
  - Surfaced from: [[summary-attention-is-all-you-need]]

### Immediate Transformer descendants (not cited — postdate Vaswani 2017)

- [ ] **Devlin, Chang, Lee, Toutanova 2018 — BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding** ([arXiv:1810.04805](https://arxiv.org/abs/1810.04805))
  - **Why:** The first major encoder-only descendant. Shows how the Transformer moved beyond translation into general-purpose language representation. Natural next step for tracing the [[encoder-decoder-architecture]] fork into the encoder-only branch. Not cited by Vaswani 2017 (postdates it).
  - Surfaced from: [[summary-attention-is-all-you-need]] (forward-looking)

## Ingested

- [x] **Vaswani et al. 2017 — Attention Is All You Need** — ingested 2026-04-13 → [[summary-attention-is-all-you-need]]

## Skipped

_(none yet)_
