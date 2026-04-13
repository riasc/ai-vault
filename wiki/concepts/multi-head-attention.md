---
type: concept
title: "Multi-Head Attention"
aliases: [multi head attention, MHA]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[attention-mechanism]]
  - [[self-attention]]
  - [[scaled-dot-product-attention]]
  - [[transformer]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Multi-Head Attention

**Multi-head attention** runs several [[scaled-dot-product-attention]] operations in parallel on different learned projections of Q, K, V, concatenates the outputs, and projects the result through one more linear layer.

## Formula

```
MultiHead(Q, K, V) = Concat(head_1, ..., head_h) W^O
head_i = Attention(Q W^Q_i, K W^K_i, V W^V_i)
```

The projections are:
- `W^Q_i, W^K_i ∈ R^{d_model × d_k}`
- `W^V_i ∈ R^{d_model × d_v}`
- `W^O ∈ R^{h·d_v × d_model}`

In the original [[transformer]] base model: **h=8**, **d_k = d_v = d_model/h = 64**, d_model = 512.

## Why multiple heads?

A single attention function, by averaging over attention-weighted positions, smears together information from the whole sequence into a single representation. This limits the model's ability to attend to distinct kinds of relationships simultaneously. Running **h heads in parallel** on lower-dimensional projections lets the model **jointly attend to information from different representation subspaces at different positions**.

Because each head uses dimension d_model/h rather than d_model, the total compute is comparable to a single full-dimensional head — multi-head is effectively "free" in FLOPs relative to the single-head baseline.

## Empirical behavior (Table 3 of the paper)

- Single-head (h=1) is **0.9 BLEU worse** than the best multi-head setting on WMT'14 En-De.
- Quality also drops off with too many heads (h=32).
- Reducing d_k hurts quality — suggests dot-product compatibility is not a trivially expressive function.
- Individual heads in the trained model learn interpretable patterns: long-distance dependency completion, anaphora resolution, and various syntactic/semantic structure. See the attention-visualization figures referenced in [[summary-attention-is-all-you-need]].

## Use in the Transformer

The [[transformer]] uses multi-head attention in three places:

1. **Encoder self-attention** — all Q, K, V come from the previous encoder layer.
2. **Masked decoder self-attention** — same, but with a mask blocking rightward attention.
3. **Encoder-decoder cross-attention** — Q from the previous decoder layer, K and V from the encoder output.

See `raw/assets/1706.03762-fig2-attention-mechanisms.pdf` (right panel).

## Sources

- [[summary-attention-is-all-you-need]]
