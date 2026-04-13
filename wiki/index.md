---
type: index
title: Wiki Index — AI/ML Research
updated: 2026-04-13
---

# Wiki Index — AI/ML Research

The master catalog. Updated on every ingest. Read first on every query.

## Concepts

- [[transformer]] — sequence transduction architecture built entirely on attention (Vaswani et al. 2017); foundation of every modern LLM.
- [[self-attention]] — attention mechanism where queries, keys, and values all come from the same sequence; O(1) max path length between positions.
- [[scaled-dot-product-attention]] — `softmax(QK^T/√d_k)V`; the attention primitive used by the Transformer.
- [[multi-head-attention]] — h parallel attention heads on different learned projections, concatenated and projected back.
- [[positional-encoding]] — sinusoidal vectors added to token embeddings to inject position information into permutation-invariant self-attention.
- [[encoder-decoder-architecture]] — two-stack pattern for sequence transduction; basis of the original Transformer and its T5/BART descendants.
- [[attention-mechanism]] — parent concept; query/key/value compatibility-based weighted sum, predating the Transformer (Bahdanau 2014, Luong 2015).

## Entities

- [[ashish-vaswani]] — first-listed author of Attention Is All You Need; designed and implemented the first Transformer models.
- [[noam-shazeer]] — proposed scaled dot-product attention, multi-head attention, and the parameter-free position representation.
- [[aidan-gomez]] — Transformer co-author; contributed to the tensor2tensor codebase.
- [[illia-polosukhin]] — Transformer co-author; co-designed and co-implemented the first Transformer models.
- [[google-brain]] — Google's deep-learning research group; institutional home of most Transformer authors.
- [[wmt-2014]] — the En-De and En-Fr machine translation benchmarks on which the Transformer set SOTA.

## Source Summaries

- [[summary-attention-is-all-you-need]] — Vaswani et al. 2017. Introduces the Transformer; SOTA on WMT'14 En-De (28.4 BLEU) and En-Fr (41.8 BLEU) at a fraction of prior training cost.

## Comparisons & Syntheses

_(none yet)_
