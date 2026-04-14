---
type: concept
title: "StripedHyena 2"
aliases: [stripedhyena 2, sh2, stripedhyena-2]
sources:
  - [[summary-evo-2]]
related:
  - [[hyena-operator]]
  - [[evo-2]]
  - [[transformer]]
  - [[self-attention]]
  - [[michael-poli]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# StripedHyena 2

## Definition

**StripedHyena 2** is a convolutional multi-hybrid sequence architecture that combines three variants of the [[hyena-operator]] with rotary [[self-attention|attention]] blocks. It is the architecture used by [[evo-2]], the successor to StripedHyena 1 (which powered Evo 1), and a practical alternative to pure-transformer architectures for long-context sequence modelling.

## Intuition

The core problem StripedHyena 2 is designed to solve: **enabling long contexts (up to 1 million tokens) without paying the quadratic memory and compute cost of full [[self-attention]]**. Pure transformers are quadratic in sequence length at each layer — at 1M tokens this is prohibitive even on the biggest GPUs. Alternatives like pure state-space models (S4, Mamba) reduce this cost but often lose some of the expressiveness of attention.

StripedHyena 2's bet is that **different layers should mix information at different ranges**. Some layers need only short-range mixing (local motif detection), some need medium-range (regulatory element spacing), and some need genome-scale reach (long-range TAD or operon structure). Rather than force all layers through the same attention-shaped keyhole, StripedHyena 2 gives each layer a different mixing operator chosen from a small library — some cheap and short, some expensive but global. Attention is kept for a subset of layers where its expressiveness is most valuable.

The result: up to 3× throughput speedup over highly optimized transformer baselines at 40B parameters / 1M context, with equal or better loss scaling on DNA.

## Formulation

StripedHyena 2 interleaves **three types of [[hyena-operator]]** with **rotary attention** blocks in a fixed repeating pattern. The three hyena operator variants:

1. **Short explicit (SE)** — small, fixed-length explicit convolution kernel. Captures local dependencies cheaply.
2. **Medium regularized (MR)** — medium-range convolution with regularization to stabilize training.
3. **Long implicit (LI)** — long-range implicit convolution (via FFT or similar), handling genome-scale reach.

**Block layout** (schematically, per the paper's Fig. 1f): repeating groups like `SE-MR-LI` followed by attention blocks, organized as the "efficient block layout" shown in the paper. The exact ordering is detailed in the companion systems paper (Ku et al. 2025, arXiv:2503.01868) — see [[summary-evo-2]] for the reference.

**Attention sub-layers** use **rotary position embeddings (RoPE)** rather than the sinusoidal [[positional-encoding]] of the original [[transformer]]. RoPE is now the dominant choice in long-context language models for its length-extrapolation properties.

**Key design decisions:**
- **Each layer mixes at a different range.** This lets the model allocate compute to the ranges that matter for each sub-layer rather than making every layer global.
- **Hyena operators scale better than attention in sequence length.** The long implicit variant can handle million-token contexts at a fraction of the quadratic cost of pure attention.
- **Attention is preserved where it matters most.** Rather than eliminating attention entirely (as pure state-space models do), StripedHyena 2 keeps it in a subset of layers where its flexibility is load-bearing.

## Variants

- **StripedHyena 1** (Poli et al. 2024, "Mechanistic design and scaling of hybrid architectures") — the immediate predecessor. Used by Evo 1. Two hyena variants instead of three.
- **StripedHyena 2** — this architecture. Used by [[evo-2]]. Three hyena variants, improved throughput and loss scaling.
- **Pure-attention transformer** — the canonical alternative. Slower at long context (quadratic scaling) but architecturally simpler.
- **Pure state-space models** (S4, Mamba) — drop attention entirely. Different tradeoff: even better long-context scaling but less flexible.

## Tradeoffs

- **Architectural complexity.** More moving parts than a pure transformer. Each operator variant has its own hyperparameters, the block layout matters, and efficient implementations require fused kernels. Understanding *why* a given layer behaves a certain way is harder than with a uniform-transformer baseline.
- **Specialized engineering required.** The 3× throughput speedup at 40B / 1M context depends on carefully fused CUDA kernels and data-parallel strategies that are not part of off-the-shelf training frameworks. See the companion systems paper (Ku et al. 2025, arXiv:2503.01868) for what was needed to train at this scale.
- **Less community tooling than transformers.** Transformers have a decade of ecosystem investment — every LLM framework supports them natively. StripedHyena 2 is new enough that tooling is sparse outside the Evo 2 release.
- **Tradeoff with task quality is favorable but not universal.** The paper shows StripedHyena 2 matches or beats transformers on DNA loss scaling and throughput, but this doesn't automatically generalize to every domain. Whether hyena-hybrid architectures beat transformers on natural language text is an open question not addressed here.

## History & Lineage

**Lineage:** Hyena Hierarchy (Poli et al. 2023, ICML) → StripedHyena 1 (Poli et al. 2024, ICML, "Mechanistic design and scaling of hybrid architectures") → **StripedHyena 2** (Ku et al. 2025, arXiv:2503.01868, "Systems and algorithms for convolutional multi-hybrid language models at scale") → [[evo-2]] (Brixi et al. 2026).

**Context:** the convolutional-hybrid direction is one of several approaches to long-context sequence modelling that emerged post-Transformer. Contemporaries include:
- State-space models: S4 (Gu et al. 2022), Mamba (Gu & Dao 2023).
- Efficient attention: Flash Attention (Dao et al. 2022), Longformer, Sparse Transformer.
- Linear attention: Performer, Linformer.

All of these share the goal of breaking the quadratic attention bottleneck. StripedHyena 2 is distinguished by its *hybrid* approach (convolutions + attention, not pure convolution) and by its demonstrated success at the 40B-parameter / 1M-context scale used in [[evo-2]].

**Significance in the field:** the first architecture to credibly train a 40B-parameter biological sequence model at 1M context, with matching or better loss scaling vs highly optimized transformer baselines. If transformer-only approaches were the right answer for long biological sequences, Evo 2 wouldn't need StripedHyena 2 — the fact that it does is evidence for the hybrid direction.

## Sources

- [[summary-evo-2]]
