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

## Definition

**Self-attention** (also called *intra-attention*) is an [[attention-mechanism|attention]] mechanism in which the queries, keys, and values all come from the same sequence. Each position produces a new representation by attending to every other position in that same sequence.

## Intuition

A recurrent layer relates position 1 to position n by propagating information through all intermediate positions — O(n) sequential steps, O(n) path length. A convolutional layer relates them faster but still needs multiple layers. Self-attention relates them **directly, in a single layer**, with O(1) maximum path length between any two positions.

Short paths make long-range dependencies easier to learn (Hochreiter et al. 2001). That's the theoretical core of the argument; empirically, it shows up as better BLEU and much faster training.

## Formulation

Given an input sequence represented as a matrix $X \in \mathbb{R}^{n \times d_{model}}$, self-attention computes Q, K, V as learned linear projections of the same $X$:

$$Q = X W^Q, \quad K = X W^K, \quad V = X W^V$$

Then applies [[scaled-dot-product-attention]]:

$$\mathrm{SelfAttention}(X) = \mathrm{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right) V$$

In the [[transformer]] this is almost always combined with [[multi-head-attention]] — h parallel self-attention operations on different learned projections, concatenated and projected back.

## Variants

- **Unmasked self-attention** — every position attends to every other position. Used in the Transformer's *encoder*.
- **Masked (causal) self-attention** — position $i$ attends only to positions $\leq i$. Illegal softmax logits are set to $-\infty$. Used in the *decoder* to preserve auto-regressive generation.
- **Restricted / windowed self-attention** — each position attends only within a local window of size $r$, reducing complexity from $O(n^2 d)$ to $O(r n d)$ at the cost of max path length $O(n/r)$. Mentioned in the original paper as future work; realized in Longformer, Sparse Transformer, etc.
- **Cross-attention** — strictly not "self" (Q comes from one sequence, K/V from another), but mechanically identical. Used in the Transformer's encoder-decoder bridge.

## Tradeoffs

- **Quadratic memory and compute in $n$** — the $n \times n$ attention matrix dominates cost at long contexts. This is the single biggest practical limitation and drives a whole research area on efficient attention (Flash Attention, sparse/linear variants, state-space models).
- **Position-agnostic** — self-attention alone treats its input as a set, not a sequence. [[positional-encoding]] must be added to distinguish word order.
- **Reduced effective resolution** — averaging attention-weighted positions can blur local detail. [[multi-head-attention]] was introduced in part to compensate.
- **Softmax saturation at high dimensions** — motivates the $\sqrt{d_k}$ scaling, see [[scaled-dot-product-attention]].

**Complexity comparison (Table 1 of the paper):**

| Layer | Complexity per layer | Sequential ops | Max path length |
| :--- | :--- | :--- | :--- |
| Self-attention | $O(n^2 \cdot d)$ | $O(1)$ | $\mathbf{O(1)}$ |
| Recurrent | $O(n \cdot d^2)$ | $O(n)$ | $O(n)$ |
| Convolutional | $O(k \cdot n \cdot d^2)$ | $O(1)$ | $O(\log_k n)$ |
| Self-attention (restricted, window $r$) | $O(r \cdot n \cdot d)$ | $O(1)$ | $O(n/r)$ |

Self-attention is also *faster* than recurrent layers when $n < d$ — typical for sentence-level NMT with byte-pair or word-piece tokenization.

## History & Lineage

**Precursors:** the term "intra-attention" shows up in Cheng et al. 2016 (LSTMs for machine reading), Parikh et al. 2016 (decomposable attention for NLI), Lin et al. 2017 (structured self-attentive sentence embeddings), and Paulus et al. 2017 (abstractive summarization). All used self-attention inside recurrent or otherwise mixed architectures.

**Decisive step:** the [[transformer]] is the first sequence transduction model built *entirely* on self-attention, with no recurrence or convolution. That's the specific contribution of [[summary-attention-is-all-you-need|Vaswani et al. 2017]].

**Descendants:** efficient attention (Flash Attention, Longformer, BigBird, Performer, linear attention), state-space alternatives (Mamba, S4 — which partially replace self-attention with convolution-like structure for long contexts), and every variant of the transformer used in modern LLMs.

## Figures

The attention visualizations in the appendix of the source paper show individual heads at layer 5/6 of the encoder learning interpretable self-attention patterns. This is the origin of the "attention is interpretable" narrative that dominated transformer interpretability research for years.

**Long-distance dependency resolution** — heads completing the phrasal verb "making ... more difficult" across intervening tokens:

![[1706.03762-long-distance-making-1.pdf]]

![[1706.03762-long-distance-making-2.pdf]]

**Anaphora resolution** — heads 5 and 6 sharply attending from the pronoun "its" to its antecedent:

![[1706.03762-anaphora-resolution-1.pdf]]

![[1706.03762-anaphora-resolution-2.pdf]]

**Different heads learning different syntactic/semantic patterns:**

![[1706.03762-attention-heads-1.pdf]]

![[1706.03762-attention-heads-2.pdf]]

## Sources

- [[summary-attention-is-all-you-need]]
