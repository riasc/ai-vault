---
type: index
title: Wiki Index — AI/ML Research
updated: 2026-04-13
---

# Wiki Index — AI/ML Research

The master catalog. Updated on every ingest. Read first on every query.

For the structural taxonomy (primitive vs architecture vs model vs method) see `CLAUDE.md` § Wiki Taxonomy.

## Concepts

### Primitives — atomic operations
- [[attention-mechanism]] — query/key/value compatibility-based weighted sum; parent concept for attention variants.
- [[self-attention]] — attention where Q, K, V all come from the same sequence; O(1) max path length between positions.
- [[scaled-dot-product-attention]] — `softmax(QK^T/√d_k)V`; the attention primitive used by the Transformer.
- [[multi-head-attention]] — h parallel attention heads on different learned projections, concatenated and projected back.
- [[positional-encoding]] — sinusoidal or learned vectors added to token embeddings to inject position information into permutation-invariant self-attention.
- [[hyena-operator]] — input-dependent long-convolution primitive; sub-quadratic alternative to attention used in StripedHyena 2.

### Architectures — design patterns
- [[transformer]] — sequence transduction architecture built entirely on attention (Vaswani et al. 2017); foundation of every modern LLM.
- [[encoder-decoder-architecture]] — two-stack pattern for sequence transduction; basis of the original Transformer and its T5/BART descendants.
- [[striped-hyena-2]] — convolutional multi-hybrid (three hyena variants + rotary attention); used by Evo 2 for 40B parameters / 1M tokens.

### Models — specific instances or classes
- [[evo-2]] — biological foundation model, 7B/40B params, 1M-token DNA context (Brixi et al. 2026).
- [[dna-foundation-model]] — class concept: large neural networks trained on raw DNA sequences across species.

### Methods — techniques and research areas
- [[sparse-autoencoder]] — feature-extraction tool for mechanistic interpretability; used by Evo 2 to surface biologically meaningful features.
- [[mechanistic-interpretability]] — research program reverse-engineering trained networks into human-understandable circuits.

## Entities

### People
- [[ashish-vaswani]] — first-listed author of Attention Is All You Need; designed and implemented the first Transformer models.
- [[noam-shazeer]] — proposed scaled dot-product attention, multi-head attention, and the parameter-free position representation.
- [[aidan-gomez]] — Transformer co-author; contributed to the tensor2tensor codebase.
- [[illia-polosukhin]] — Transformer co-author; co-designed and co-implemented the first Transformer models.
- [[brian-hie]] — co-senior author of Evo 2 and core investigator at Arc Institute.
- [[patrick-hsu]] — co-senior author of Evo 2 and core investigator at Arc Institute.
- [[michael-poli]] — architect of the Hyena and StripedHyena families; key Evo 2 contributor.

### Orgs
- [[google-brain]] — Google's deep-learning research group; institutional home of the Transformer authors.
- [[arc-institute]] — independent biomedical research institute; lead institution for the Evo series.

### Datasets
- [[wmt-2014]] — En-De and En-Fr machine translation benchmarks; the original Transformer's headline evaluation.
- [[opengenome2]] — 8.8+ trillion nucleotides spanning all domains of life; training dataset for Evo 2.

## Source Summaries

### 2017
- [[summary-attention-is-all-you-need]] — Vaswani et al., NeurIPS 2017. Introduces the Transformer; SOTA on WMT'14 at a fraction of prior training cost.

### 2026
- [[summary-evo-2]] — Brixi et al., Nature 2026. Introduces Evo 2; first cross-domain DNA foundation model with 1M-token context.

## Comparisons & Syntheses

_(none yet)_
