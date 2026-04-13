---
type: concept
title: "Scaled Dot-Product Attention"
aliases: [scaled dot product attention]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[attention-mechanism]]
  - [[multi-head-attention]]
  - [[self-attention]]
  - [[transformer]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Scaled Dot-Product Attention

The **scaled dot-product attention** is the primitive attention operation used in the [[transformer]]:

```
Attention(Q, K, V) = softmax(QK^T / √d_k) V
```

where Q, K, V are query, key, and value matrices, and d_k is the dimension of the queries and keys.

## Mechanics

![[1706.03762-fig2-attention-mechanisms.pdf]]

Step by step (Figure 2, left panel):

1. **MatMul** — compute `QK^T` (pairwise dot products between each query and each key).
2. **Scale** — divide by √d_k.
3. **Mask (optional)** — set illegal positions to −∞ (used in decoder self-attention to prevent rightward attention).
4. **SoftMax** — row-wise, producing attention weights that sum to 1 per query.
5. **MatMul** — multiply attention weights by V to get the output.

## Why scale by √d_k?

Assume the components of q and k are independent random variables with mean 0 and variance 1. Then the dot product `q · k = Σ q_i k_i` has mean 0 and variance d_k. For large d_k the magnitudes of the dot products grow, which pushes softmax into regions where it's nearly saturated — the gradients become vanishingly small. Dividing by √d_k restores unit variance and keeps the softmax in its usable range.

The ablation in Table 1 of the paper — comparing additive attention to dot-product attention at varying d_k — is what motivated this choice. Additive attention outperforms unscaled dot-product at large d_k; scaling closes the gap while preserving the speed advantage of dot-product.

## Vs. additive attention

- **Additive** (Bahdanau 2014) — uses a small feed-forward network for compatibility.
- **Dot-product** — identical to the scaled variant except without the √d_k factor.
- Theoretical complexity is similar; dot-product is much faster in practice because it reduces to matrix multiplication (highly optimized on modern hardware — GPUs, TPUs).

## Sources

- [[summary-attention-is-all-you-need]]
