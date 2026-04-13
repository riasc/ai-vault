---
type: concept
title: "Attention Mechanism"
aliases: [attention, attention function]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[self-attention]]
  - [[scaled-dot-product-attention]]
  - [[multi-head-attention]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Attention Mechanism

## Definition

An **attention function** maps a query and a set of key-value pairs to an output. The output is a weighted sum of the values, where the weight on each value is computed by a compatibility function between the query and the corresponding key.

## Intuition

Attention lets a model relate two positions in a sequence **in a single step**, regardless of how far apart they are. This bypasses the sequential bottleneck of recurrent models (which must propagate information through O(n) intermediate hidden states) and the receptive-field bottleneck of convolutional models (which need multiple layers to cover long distances). It is the key primitive that made the [[transformer]] possible.

## Formulation

For a single query $q$ over keys $\{k_i\}$ and values $\{v_i\}$:

$$\mathrm{Output} = \sum_i \mathrm{softmax}(\mathrm{compat}(q, k_i)) \cdot v_i$$

In matrix form with queries $Q$, keys $K$, values $V$:

$$\mathrm{Attention}(Q, K, V) = \mathrm{softmax}(\mathrm{compat}(Q, K)) \cdot V$$

The different attention variants correspond to different choices of `compat`.

## Variants

- **Additive attention** (Bahdanau 2014) — `compat(q, k) = v^T tanh(W_q q + W_k k)`. Uses a small feed-forward network with one hidden layer. Originally used inside RNN encoder-decoders for NMT.
- **Dot-product attention** (Luong 2015) — `compat(q, k) = q · k`. Faster in practice than additive because it reduces to matrix multiplication.
- **[[scaled-dot-product-attention]]** (Vaswani 2017) — dot-product divided by $\sqrt{d_k}$ to prevent softmax saturation at high dimensions. The attention primitive used in the Transformer.
- **[[self-attention]]** — a *usage pattern*, not a compat function: Q, K, V all come from the same sequence.
- **[[multi-head-attention]]** — another usage pattern: run h attention operations in parallel on learned projections, concatenate, and project back.

## Tradeoffs

- **Compatibility function complexity affects quality.** Row (B) of Table 3 in the Transformer paper shows that reducing $d_k$ hurts BLEU, suggesting dot-product compatibility is not trivially expressive. More expressive compat functions (like additive) can do better at small $d_k$, at the cost of speed.
- **Quadratic in sequence length** when used as [[self-attention]] — the attention matrix is n×n. This is the main scaling limitation for modern LLMs.
- **Position-agnostic** — attention treats inputs as a set of (key, value) pairs. Any notion of order must be encoded separately (e.g. [[positional-encoding]]).

## History & Lineage

**Origin:** Bahdanau, Cho, Bengio (2014) introduced additive attention inside an RNN encoder-decoder for neural machine translation. The goal was to let the decoder focus on different parts of the source sentence at each output step, rather than compressing the entire source into a single fixed-length vector.

**Evolution:** Luong et al. (2015) simplified to dot-product variants. Parikh et al. (2016, "A Decomposable Attention Model") showed attention without recurrence for natural language inference. [[summary-attention-is-all-you-need|Vaswani et al. (2017)]] took the decisive step of building a whole model out of attention — no recurrence, no convolution.

**Descendants:** after 2017, "attention" in ML almost always means [[scaled-dot-product-attention]] inside a [[transformer]]. More recent work focuses on efficient attention (Flash Attention, linear attention, Performer, sparse patterns) or alternative primitives that partially replace it (state-space models like Mamba).

## Sources

- [[summary-attention-is-all-you-need]]
