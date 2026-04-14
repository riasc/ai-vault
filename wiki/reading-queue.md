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

### Evo 2 lineage (from Brixi et al. 2026 bibliography)

- [ ] **Nguyen et al. 2024 — Sequence modeling and design from molecular to genome scale with Evo** (*Science* 386, eado9336)
  - **Why:** The direct predecessor to [[evo-2]]. StripedHyena 1 architecture, 7B params, prokaryote/phage only, 131k context. Essential for understanding what Evo 2 changed (architectural upgrade to StripedHyena 2, expansion to eukaryotes, context extension to 1M). Without Evo 1, the Evo 2 contribution is hard to size.
  - Surfaced from: [[summary-evo-2]]

- [ ] **Ku et al. 2025 — Systems and algorithms for convolutional multi-hybrid language models at scale** ([arXiv:2503.01868](https://arxiv.org/abs/2503.01868))
  - **Why:** Companion systems paper to [[striped-hyena-2]] / [[evo-2]]. Engineering details of how to train a 40B-parameter hybrid model at 1M context — fused kernels, parallelism strategies, throughput optimizations. The "how it was actually built" companion to the "what it does" Nature paper.
  - Surfaced from: [[summary-evo-2]]

- [ ] **Poli et al. 2023 — Hyena Hierarchy: Towards Larger Convolutional Language Models** (ICML 2023)
  - **Why:** Original [[hyena-operator]] paper. Introduces the input-dependent long-convolution primitive that eventually grew into [[striped-hyena-2]]. Essential for understanding the architectural lineage and the rationale behind sub-quadratic attention alternatives.
  - Surfaced from: [[summary-evo-2]]

- [ ] **Cunningham, Ewart, Smith, Huben, Sharkey 2023 — Sparse Autoencoders Find Highly Interpretable Features in Language Models** ([arXiv:2309.08600](https://arxiv.org/abs/2309.08600))
  - **Why:** Foundational SAE-for-interpretability paper. The technique Evo 2 uses for [[mechanistic-interpretability]] of biology, but applied originally to language models. Connects the wiki to the broader mech-interp research thread (Anthropic's Circuits work, Templeton et al. 2024 on Claude 3 Sonnet, etc.).
  - Surfaced from: [[summary-evo-2]]

- [ ] **Dalla-Torre et al. 2024 — Nucleotide Transformer: building and evaluating robust foundation models for human genomics** (*Nat. Methods* 22, 287–297)
  - **Why:** The prior major [[dna-foundation-model]]. Evo 2 benchmarks against Nucleotide Transformer extensively (variant effect prediction, exon classification). Important context for what "competitive" means in this space pre-Evo 2.
  - Surfaced from: [[summary-evo-2]]

## Ingested

- [x] **Vaswani et al. 2017 — Attention Is All You Need** — ingested 2026-04-13 → [[summary-attention-is-all-you-need]]
- [x] **Brixi et al. 2026 — Genome modelling and design across all domains of life with Evo 2** — ingested 2026-04-13 → [[summary-evo-2]]

## Skipped

_(none yet)_
