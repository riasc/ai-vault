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

## Definition

**Scaled dot-product attention** is the primitive attention operation used in the [[transformer]]:

$$\mathrm{Attention}(Q, K, V) = \mathrm{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right) V$$

where $Q$, $K$, $V$ are query, key, and value matrices, and $d_k$ is the dimension of the queries and keys.

## Intuition

The design is chosen for two reasons, one practical and one numerical:

1. **Dot-product for speed.** The compatibility function $q \cdot k$ reduces to matrix multiplication, which is massively optimized on modern hardware (GPUs, TPUs). Additive attention (Bahdanau-style) uses a small feed-forward network instead, with similar theoretical complexity but much worse practical throughput.
2. **$\sqrt{d_k}$ scaling for stability.** Without scaling, dot products grow in magnitude as $d_k$ increases, pushing the softmax into saturated regions where gradients vanish. Dividing by $\sqrt{d_k}$ restores unit-variance behavior and keeps the softmax usable.

## Formulation

Given query matrix $Q \in \mathbb{R}^{n \times d_k}$, key matrix $K \in \mathbb{R}^{m \times d_k}$, and value matrix $V \in \mathbb{R}^{m \times d_v}$:

$$\mathrm{Attention}(Q, K, V) = \mathrm{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right) V$$

Step by step (Figure 2, left panel):

1. **MatMul** — compute $QK^T$ (pairwise dot products between each query and each key).
2. **Scale** — divide by $\sqrt{d_k}$.
3. **Mask (optional)** — set illegal positions to $-\infty$ (used in decoder [[self-attention]] to block rightward attention).
4. **SoftMax** — row-wise, producing attention weights that sum to 1 per query.
5. **MatMul** — multiply attention weights by $V$ to get the output.

**Variance argument for the scaling factor:** assume the components of $q$ and $k$ are independent random variables with mean 0 and variance 1. Then the dot product $q \cdot k = \sum_{i=1}^{d_k} q_i k_i$ has mean 0 and variance $d_k$. Dividing by $\sqrt{d_k}$ normalizes the variance back to 1, regardless of $d_k$.

## Variants

- **Dot-product attention** (unscaled) — same, without the $\sqrt{d_k}$ factor. Works fine at small $d_k$ but degrades at large $d_k$ due to softmax saturation. Empirically, additive attention *outperforms* unscaled dot-product at large $d_k$, which is what motivated the scaling trick in the first place.
- **Additive attention** (Bahdanau 2014) — uses $v^T \tanh(W_q q + W_k k)$ as the compatibility function. Slower in practice.
- **Flash Attention** — same mathematical operation, implemented with tiling and kernel fusion for much higher throughput and lower memory. Not a different formula — a different implementation.
- **Linear attention, Performer, etc.** — approximate the softmax with a kernel factorization to avoid the $n \times n$ attention matrix.

## Tradeoffs

- **$O(n^2)$ memory and compute** in the sequence length, through the attention matrix $QK^T \in \mathbb{R}^{n \times m}$. This is the main scaling limit for long contexts.
- **Compatibility function is not richly expressive.** Row (B) of Table 3 in the Transformer paper shows that reducing $d_k$ hurts quality — the authors note that "determining compatibility is not easy and that a more sophisticated compatibility function than dot product may be beneficial." This is an acknowledged limitation.
- **Sharp softmax at high temperature.** Even with scaling, the softmax can concentrate sharply on a single key, which reduces gradient flow through other positions. Various tricks (attention dropout, entropy regularization) mitigate this.

## History & Lineage

**Precursors:** Luong et al. (2015) introduced dot-product attention as a simpler, faster alternative to Bahdanau's additive attention. The unscaled dot-product was known to have stability issues at high $d_k$, but no one had a clean fix.

**The paper:** [[summary-attention-is-all-you-need|Vaswani et al. (2017)]] introduced the $\sqrt{d_k}$ scaling, turning dot-product attention from a finicky variant into the industry standard. The argument is a single paragraph in section 3.2.1 and is one of the paper's highest-ROI contributions — it's the reason "scaled dot-product" stuck as the canonical attention formula.

**Descendants:** every modern transformer implementation uses this formula. Efficiency work (Flash Attention, etc.) changes how it's computed, not what it computes.

## Figures

**Figure 2 (left panel) — Scaled Dot-Product Attention:**

![[1706.03762-fig2-attention-mechanisms.pdf]]

## Sources

- [[summary-attention-is-all-you-need]]
