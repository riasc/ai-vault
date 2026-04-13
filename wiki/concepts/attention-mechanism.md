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

An **attention function** maps a query and a set of key-value pairs to an output, where the query, keys, values, and output are all vectors. The output is a weighted sum of the values, with the weights computed by a compatibility function between the query and each key.

Formally, for a single query q over keys `{k_i}` and values `{v_i}`:

```
Output = Σ_i softmax(compat(q, k_i)) · v_i
```

## Origin (pre-Transformer)

Attention mechanisms emerged in neural machine translation to let a decoder focus on different parts of an encoded source sentence at each output step:

- **Bahdanau attention** (2014) — additive attention: `compat(q, k) = v^T tanh(W_q q + W_k k)`. Originally used inside RNN encoder-decoders for NMT.
- **Luong attention** (2015) — multiple variants (dot-product, general, concat).

The key property is that attention lets the model relate positions at arbitrary distance in a single step, bypassing the sequential bottleneck of recurrence.

## Variants

- **Additive attention** — compatibility function uses a small feed-forward network with a single hidden layer.
- **Dot-product attention** — `compat(q, k) = q · k`. Much faster in practice than additive because it reduces to matrix multiplication.
- **[[scaled-dot-product-attention]]** — dot-product divided by √d_k to prevent softmax saturation at high dimensions.
- **[[self-attention]]** — queries, keys, and values all come from the same sequence.
- **[[multi-head-attention]]** — multiple attention functions run in parallel on different learned projections.

## Why scale dot-product attention?

Additive and dot-product attention have similar theoretical complexity, but dot-product is faster in practice. However, for large d_k the dot products grow in magnitude (variance scales as d_k), pushing the softmax into saturated regions where gradients vanish. Dividing by √d_k restores variance-1 conditions and keeps the softmax in its usable range. This is the central trick in the [[transformer]]'s attention.

## Sources

- [[summary-attention-is-all-you-need]]
