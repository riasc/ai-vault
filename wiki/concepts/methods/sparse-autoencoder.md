---
type: concept
title: "Sparse Autoencoder (SAE)"
aliases: [SAE, sparse autoencoder, batch-topk SAE]
sources:
  - [[summary-evo-2]]
related:
  - [[mechanistic-interpretability]]
  - [[evo-2]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Sparse Autoencoder (SAE)

## Definition

A **sparse autoencoder** (SAE) is a small neural network trained to reconstruct the activations of a (much larger) target model — typically a transformer or other deep network — through a high-dimensional bottleneck where most dimensions are constrained to be zero on any given input. The non-zero dimensions of the bottleneck (the "active features") become candidate **interpretable units of computation** in the target model.

In [[mechanistic-interpretability]] research, SAEs are the dominant tool for decomposing neural activations into approximately monosemantic features.

## Intuition

The problem SAEs solve: a single neuron in a large language model is usually **polysemantic** — it fires in response to many unrelated concepts at once, because the model packs more features into its representation space than there are dimensions. Looking at "what activates neuron 4123" gives noisy, mixed answers.

The hypothesis is that the model's activation vectors are sparse linear combinations of an over-complete *feature dictionary* — there are many possible features, but only a small number are active at any given input. If you can recover the dictionary, each feature should correspond to a single coherent concept (the *monosemanticity hypothesis*).

A sparse autoencoder is the way to recover that dictionary. You train an encoder that maps the model's activations into a much higher-dimensional space (often 8-64× larger), constrain only a small number of dimensions to be active on any given input, and train a decoder to reconstruct the original activations from this sparse code. The encoder weights then form a candidate dictionary of features.

## Formulation

Let $h \in \mathbb{R}^d$ be a vector of activations from a target model layer (e.g., the residual stream of a transformer at layer $L$). The SAE consists of:

- **Encoder:** $z = \mathrm{TopK}(\mathrm{ReLU}(W_e h + b_e))$ where $W_e \in \mathbb{R}^{D \times d}$, $D \gg d$
- **Decoder:** $\hat{h} = W_d z + b_d$
- **Loss:** $\mathcal{L} = \|h - \hat{h}\|^2 + \lambda \|z\|_0$ (in practice, the L0 penalty is replaced by various sparsity-inducing schemes)

The hyperparameter $D/d$ is the **dictionary multiplier** (how much wider the bottleneck is than the input). The sparsity constraint forces only $k \ll D$ dimensions of $z$ to be non-zero per input.

**Variants of the sparsity mechanism:**

- **L1-penalized SAE** — soft sparsity via L1 regularization on $z$ (Cunningham et al. 2023, "Sparse autoencoders find highly interpretable features in language models").
- **TopK SAE** — hard sparsity by keeping only the top $k$ activations and zeroing the rest. Cleaner training dynamics, no need to tune the L1 coefficient.
- **Batch-TopK SAE** (Bussmann, Leask, Nanda 2024) — keep the top $k \cdot \text{batch size}$ activations across the whole batch rather than per-example. Allows variable per-example sparsity. **This is the variant used in [[evo-2]]**, trained on 1 billion tokens of activations from Evo 2 layer 26.

## Variants

See above — the main axis of variation is the sparsity mechanism (L1, TopK, Batch-TopK, JumpReLU, gated SAE, etc.). Other axes:

- **Where in the model to train the SAE.** Common choices: residual stream, MLP outputs, attention outputs. Different layers expose different features.
- **Dictionary size.** Bigger dictionaries find more features but cost more compute and risk dictionary "dead features" (entries that never activate).
- **Training data.** Activations from in-distribution inputs vs. diverse mixtures. For [[evo-2]], the SAE was trained on representations from 1 billion tokens evenly split across complete eukaryotic and prokaryotic genomes.

## Tradeoffs

- **Reconstruction quality vs sparsity is a hard tradeoff.** Higher sparsity (smaller $k$) gives more interpretable features but loses reconstruction fidelity, which means the features may not capture everything the model is doing.
- **Dead features.** A common failure mode — many SAE dictionary entries never activate on any input. Wasted capacity. Various tricks (auxiliary losses, resampling) mitigate this.
- **Feature splitting.** A single semantic concept can get split across multiple dictionary entries, especially as $D$ grows. This is sometimes desired (more granular features) and sometimes a bug.
- **No ground truth for "interpretability."** Whether a feature is "interpretable" is itself a judgment call. Validation is typically done by inspection (which inputs make the feature fire?), correlation with known labels (does this feature fire on annotated TF binding sites?), or steering experiments (does forcing this feature on/off change model output in the expected way?).
- **Causal claims are harder than they look.** A feature that *correlates* with a concept may not be *used by* the model to compute behavior involving that concept. Steering experiments help bridge this gap but are not foolproof.

## History & Lineage

**Origin** in mech interp: Cunningham, Ewart, Smith, Huben, Sharkey (2023, *"Sparse autoencoders find highly interpretable features in language models"*, arXiv:2309.08600). First demonstrated SAEs as a practical interpretability tool on small language models.

**Scaling:** Bricken et al. 2023 ("Towards monosemanticity") and Templeton et al. 2024 ("Scaling monosemanticity") at Anthropic scaled SAEs to Claude 3 Sonnet, finding millions of interpretable features including high-level abstract concepts. These papers are the proof-of-concept that SAEs work at production-LLM scale.

**Variant evolution:** TopK SAEs (Gao et al. 2024) → Batch-TopK SAEs (Bussmann et al. 2024) → JumpReLU SAEs (Rajamanoharan et al. 2024). Each variant trades off training stability vs reconstruction quality vs interpretability.

**This paper's contribution to SAE methodology:** [[evo-2]] is one of the first applications of SAEs to a non-language-model domain (DNA). The fact that SAE features on Evo 2 spontaneously align with known biological annotations (prophages, exon boundaries, TF motifs, protein secondary structure) is evidence that the SAE-as-feature-dictionary technique transfers across modalities.

## Sources

- [[summary-evo-2]]
