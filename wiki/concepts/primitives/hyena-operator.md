---
type: concept
title: "Hyena Operator"
aliases: [hyena, hyena layer, hyena hierarchy]
sources:
  - [[summary-evo-2]]
related:
  - [[striped-hyena-2]]
  - [[self-attention]]
  - [[attention-mechanism]]
created: 2026-04-13
updated: 2026-04-13
confidence: medium
---

# Hyena Operator

## Definition

A **hyena operator** is a sub-quadratic sequence-mixing primitive based on input-dependent long convolutions. It is used as an alternative to [[self-attention]] in architectures like [[striped-hyena-2]]: it mixes information across positions in a sequence, but at lower compute and memory cost than attention for long sequences.

Introduced in *Hyena Hierarchy: Towards Larger Convolutional Language Models* (Poli et al., ICML 2023). Further developed in *Mechanistic design and scaling of hybrid architectures* (Poli et al., ICML 2024) and the convolutional multi-hybrid follow-up by Ku et al. (2025, arXiv:2503.01868) that underpins [[evo-2]].

## Intuition

The motivation is identical to efficient-attention variants: **relate arbitrary positions in a long sequence without paying the quadratic cost of full [[self-attention]]**. The insight is that a carefully designed *input-dependent long convolution* can achieve much of what attention achieves — information mixing across positions with context-dependent weights — at near-linear cost in sequence length.

"Input-dependent" is the key word. A vanilla convolution has fixed weights; the same filter is applied to every input. A hyena operator's filter is produced as a function of the input itself, so different inputs get different effective filters — which is what gives it attention-like expressiveness. The filter is parameterized implicitly (typically via a small MLP conditioned on position), so the effective kernel can be as long as the full sequence without blowing up parameter count.

## Formulation

A hyena operator can be described as a stack of alternating:

1. **Input-dependent gating** (elementwise multiplications)
2. **Long implicit convolutions** (parameterized by a small network, computed efficiently via FFT)

At a high level, for an input sequence $u$, a hyena layer computes:

$$y = H_N(u, q) \cdot v$$

where $q, v$ are learned projections of $u$ and $H_N$ is a recursion of $N$ interleaved gating and convolution steps. The convolution kernels are implicit — produced by a small network rather than stored as explicit weights — which makes the kernel length independent of parameter count.

*(The full formalization is in the Hyena Hierarchy paper and its successors; see [[summary-evo-2]] references or the [[reading-queue]] for the primary sources. This wiki page will get a proper formulation section once those papers are ingested directly.)*

## Variants

Per the Fig. 1f schematic in [[summary-evo-2]], [[striped-hyena-2]] uses three hyena operator variants, chosen to span a range of effective mixing distances:

1. **Short explicit (SE)** — small explicit convolution kernel. Cheap, captures local dependencies.
2. **Medium regularized (MR)** — medium-range convolution with regularization for training stability.
3. **Long implicit (LI)** — long-range implicit convolution, computed via FFT, for global reach.

Other variants exist in the broader Hyena literature — different kernel parameterizations, different gating schemes, different implicit-kernel networks.

## Tradeoffs

- **Cheaper than [[self-attention]] at long sequences.** The implicit long convolution is computed via FFT in $O(n \log n)$ rather than $O(n^2)$. For million-token contexts the difference is decisive.
- **Input-dependence is essential.** Without input-dependent gating, a hyena operator is just a standard long convolution — which is much less expressive than attention. The gating is what gives hyena its flexibility, and also its complexity.
- **Harder to interpret than attention.** Attention weights have a direct "what attends to what" interpretation. Hyena operators are harder to probe — mechanistic interpretability work on hyena-hybrid models is still early.
- **Engineering demands.** Efficient implementations require fused kernels, careful FFT batching, and attention to memory layout. Not as plug-and-play as standard attention kernels.
- **Benefits depend on the domain.** On DNA (long sequences, strong local structure) the hyena approach does well. Whether it wins in other domains like natural language text is less clear.

## History & Lineage

**Hyena Hierarchy** (Poli et al., ICML 2023) introduced the operator as a near-drop-in alternative to attention for language modelling, showing competitive perplexity at much lower cost for long sequences.

**StripedHyena 1** (Poli et al., ICML 2024) formalized the *hybrid* direction: alternate hyena operators and attention layers in a stack, rather than replacing attention entirely. Used in Evo 1.

**StripedHyena 2** (Ku et al. 2025, arXiv:2503.01868) extends this to three hyena variants of different ranges plus attention, with the engineering needed to train at 40B parameters and 1M context. Used in [[evo-2]].

**Sibling architectures:** S4, Mamba, and other state-space models pursue similar goals via different mathematical machinery (state-space recurrences rather than input-dependent convolutions). The hyena/state-space distinction is technical but the research-community positioning is similar — both are post-attention alternatives for long-context modelling.

## Sources

- [[summary-evo-2]]
