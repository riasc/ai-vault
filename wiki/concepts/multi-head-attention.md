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

## Definition

**Multi-head attention** runs $h$ [[scaled-dot-product-attention]] operations in parallel on different learned projections of $Q$, $K$, $V$, concatenates the outputs, and projects the result through one more linear layer.

## Intuition

A single attention function, by averaging over attention-weighted positions, smears together information from the whole sequence into one representation. If the model needs to attend to *one thing* at this position (e.g. the direct object of the verb), fine — but if it needs to attend to *several different things simultaneously* (direct object, subject agreement, prepositional phrase attachment, discourse coreference), a single attention head has to compromise.

Running $h$ heads in parallel, each on a lower-dimensional projection of the same $Q$, $K$, $V$, lets the model **jointly attend to information from different representation subspaces at different positions**. Because each head uses dimension $d_{model}/h$ rather than $d_{model}$, the total compute is comparable to a single full-dimensional head — multi-head is effectively "free" in FLOPs.

Empirically, the different heads specialize: some track syntactic structure, some resolve anaphora, some span long-range dependencies. This specialization is visible in the attention visualizations referenced in [[self-attention]].

## Formulation

$$\mathrm{MultiHead}(Q, K, V) = \mathrm{Concat}(\mathrm{head}_1, \ldots, \mathrm{head}_h) W^O$$

$$\mathrm{head}_i = \mathrm{Attention}(Q W^Q_i, K W^K_i, V W^V_i)$$

The projection matrices are:
- $W^Q_i, W^K_i \in \mathbb{R}^{d_{model} \times d_k}$
- $W^V_i \in \mathbb{R}^{d_{model} \times d_v}$
- $W^O \in \mathbb{R}^{h \cdot d_v \times d_{model}}$

In the original [[transformer]] base model: **$h=8$**, **$d_k = d_v = d_{model}/h = 64$**, $d_{model} = 512$. In the big model, $h=16$ and $d_k = d_v = 64$ still.

## Variants

- **Multi-Query Attention (MQA)** — Shazeer 2019. All heads share a single $K$ and $V$ projection; only $Q$ is per-head. Dramatically reduces KV-cache memory for autoregressive inference at a small quality cost. Not in the source paper, but important downstream.
- **Grouped-Query Attention (GQA)** — Ainslie et al. 2023. Compromise between full multi-head and MQA: groups of $Q$ heads share $K$/$V$. Used in Llama 2, Mistral, and most modern LLMs.
- **Local multi-head attention** — heads with restricted windows (Longformer-style).
- **Different head specializations** — not a different formula, but a research direction: analyzing which heads do what, pruning redundant heads, etc.

## Tradeoffs

- **KV-cache memory during inference.** Each head stores its own $K$ and $V$; at long contexts this dominates inference memory. MQA/GQA exist specifically to address this.
- **Diminishing returns from more heads.** Row (A) of Table 3 shows single-head is **0.9 BLEU worse** than $h=8$ on WMT'14 En-De, but $h=32$ is also worse than $h=8$. There's an optimum, and it's not "more heads = always better."
- **Reducing $d_k$ per head hurts quality.** Row (B) of Table 3 shows that making heads too narrow degrades BLEU — the dot-product compatibility function needs enough dimensionality to express rich patterns.
- **FLOPs are ~free, memory is not.** Total compute is roughly constant across $h$ at fixed $d_{model}$, but the per-head $K$/$V$ storage scales with $h$.

## History & Lineage

**Attribution:** per the author footnote of [[summary-attention-is-all-you-need]], [[noam-shazeer|Noam Shazeer]] proposed multi-head attention along with [[scaled-dot-product-attention]] and the parameter-free position representation. These are arguably the three key technical innovations of the Transformer paper.

**Descendants:**
- MQA (Shazeer 2019) reduces heads on the K/V side for inference efficiency.
- GQA (Ainslie 2023) is the current default compromise — used by Llama 2+, Mistral, and most modern LLMs.
- Interpretability research on "which head does what" is a whole subfield (Clark et al. 2019, Voita et al. 2019, etc.).

## Figures

**Figure 2 (right panel) — Multi-Head Attention.** Shows $h$ parallel linear projections of $Q$, $K$, $V$, each fed into a scaled dot-product attention, then concatenated and linearly projected:

![[1706.03762-fig2-attention-mechanisms.pdf]]

## Sources

- [[summary-attention-is-all-you-need]]
