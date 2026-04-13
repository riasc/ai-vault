---
type: concept
title: "Self-Attention"
aliases: [intra-attention, self attention]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[attention-mechanism]]
  - [[scaled-dot-product-attention]]
  - [[multi-head-attention]]
  - [[transformer]]
  - [[positional-encoding]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Self-Attention

**Self-attention** (also called *intra-attention*) is an [[attention-mechanism|attention]] mechanism in which the queries, keys, and values all come from the same sequence. Each position in the sequence attends to every other position (or every earlier position, in the masked case), producing a new representation that mixes information across positions.

## Why it matters

Self-attention reduces the **maximum path length** between any two positions in a sequence to **O(1)**. For comparison (Table 1 in [[summary-attention-is-all-you-need]]):

| Layer | Complexity | Sequential ops | Max path length |
| :--- | :--- | :--- | :--- |
| Self-attention | O(n²·d) | O(1) | **O(1)** |
| Recurrent | O(n·d²) | O(n) | O(n) |
| Convolutional | O(k·n·d²) | O(1) | O(log_k n) |
| Self-attention (restricted, window r) | O(r·n·d) | O(1) | O(n/r) |

Short paths make long-range dependencies easier to learn — a long-standing challenge in sequence modeling (Hochreiter et al., 2001). When n < d (typical for sentence-level NMT with byte-pair or word-piece tokenization), self-attention is also *faster* than recurrent layers.

## Tradeoffs

- **Quadratic memory/compute in n** — the n×n attention matrix. This is the main practical limitation for long contexts and drives research on efficient attention (Longformer, sparse attention, Flash Attention, state-space models).
- **Position-agnostic** — self-attention alone has no notion of order; [[positional-encoding]] must be added.
- **Reduced effective resolution** — averaging attention-weighted positions can blur local detail. [[multi-head-attention]] was introduced in part to compensate.

## Use in the Transformer

The [[transformer]] uses self-attention in three contexts:

1. **Encoder self-attention** — every encoder position attends to every other encoder position.
2. **Masked decoder self-attention** — each decoder position attends only to positions ≤ itself, preserving the auto-regressive property. Masking is implemented by setting illegal softmax logits to −∞.
3. **Encoder-decoder cross-attention** — strictly not "self" (queries from the decoder, keys/values from the encoder), but mechanically identical.

## Interpretability

Attention visualizations from the Transformer paper (appendix) show individual heads at layer 5/6 learning interpretable behaviors: anaphora resolution, long-distance dependency tracking, and various syntactic/semantic patterns. See `raw/assets/1706.03762-anaphora-resolution-1.pdf`, `raw/assets/1706.03762-long-distance-making-1.pdf`, and related files. This paper originated the "attention is interpretable" narrative that dominated transformer interpretability research for years.

## Sources

- [[summary-attention-is-all-you-need]]
