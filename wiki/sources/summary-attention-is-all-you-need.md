---
type: source
title: "Attention Is All You Need"
slug: summary-attention-is-all-you-need
source_file: raw/papers/1706.03762v7-attention-is-all-you-need.tar.gz
author: "Vaswani, Shazeer, Parmar, Uszkoreit, Jones, Gomez, Kaiser, Polosukhin"
date_published: 2017-06-12
date_ingested: 2026-04-13
key_claims:
  - Sequence transduction can be done entirely with attention — no recurrence, no convolution
  - Self-attention gives O(1) maximum path length between any two positions, vs O(n) for RNNs and O(log_k n) for convolutions
  - Scaling dot-product attention by 1/√d_k is necessary to prevent softmax saturation when d_k is large
  - Multi-head attention lets the model jointly attend to information from different representation subspaces
  - The Transformer achieves SOTA on WMT'14 En-De (28.4 BLEU) and En-Fr (41.8 BLEU) at a small fraction of prior training cost
related: [[transformer]], [[self-attention]], [[scaled-dot-product-attention]], [[multi-head-attention]], [[positional-encoding]], [[encoder-decoder-architecture]], [[attention-mechanism]], [[ashish-vaswani]], [[noam-shazeer]], [[aidan-gomez]], [[illia-polosukhin]], [[google-brain]], [[wmt-2014]]
confidence: high
---

# Attention Is All You Need

**Vaswani, Shazeer, Parmar, Uszkoreit, Jones, Gomez, Kaiser, Polosukhin** — NeurIPS 2017. Introduces the [[transformer]], the first sequence transduction model built entirely on [[attention-mechanism|attention]], discarding recurrence and convolution.

## Abstract

Dominant sequence transduction models use RNN- or CNN-based encoder-decoders, often augmented with attention. This paper proposes the **Transformer**, a purely attention-based architecture that is simpler, more parallelizable, and faster to train. It achieves **28.4 BLEU** on WMT 2014 English-to-German (+2 BLEU over prior SOTA, including ensembles) and **41.8 BLEU** on English-to-French after 3.5 days of training on 8 P100 GPUs — a small fraction of the cost of prior SOTA models. The Transformer also generalizes well: applied to English constituency parsing (WSJ, Penn Treebank), it outperforms all prior published models except the RNNG of Dyer et al.

## Key Contributions

1. **The Transformer architecture** — a purely attention-based [[encoder-decoder-architecture]]. See [[transformer]].
2. **[[self-attention|Self-attention]] as a first-class layer type** — relating all positions in a sequence in O(1) sequential ops and O(1) maximum path length between any two positions, unlike recurrent (O(n)/O(n)) or convolutional (O(1)/O(log_k n)) layers.
3. **[[scaled-dot-product-attention|Scaled dot-product attention]]** — `softmax(QK^T / √d_k) V`. The √d_k scaling prevents softmax saturation when d_k is large. Proposed by [[noam-shazeer|Noam Shazeer]] per the author footnote.
4. **[[multi-head-attention|Multi-head attention]]** — h=8 parallel heads with d_k = d_v = d_model/h = 64, projecting into different learned subspaces, concatenated and linearly projected back. Also proposed by Shazeer.
5. **Sinusoidal [[positional-encoding]]** — `PE(pos, 2i) = sin(pos / 10000^{2i/d_model})` (cos for odd i), added to input embeddings. Learned positional embeddings give nearly identical results; sinusoidal was chosen for potential length extrapolation.

## Method

### Architecture

The Transformer is an [[encoder-decoder-architecture]] with N=6 stacked identical layers on each side.

**Encoder:** each layer has two sub-layers:
1. Multi-head self-attention
2. Position-wise feed-forward network

**Decoder:** each layer has three sub-layers:
1. Masked multi-head self-attention
2. Multi-head encoder-decoder cross-attention
3. Position-wise feed-forward network

Each sub-layer is wrapped as `LayerNorm(x + Sublayer(x))`. Output dimension $d_{model} = 512$ (base) or 1024 (big).

The decoder's self-attention is masked (illegal logits set to $-\infty$) to prevent positions from attending to subsequent positions, preserving the auto-regressive property.

**Attention is used in three places:**
- **Encoder self-attention** — Q, K, V all from the previous encoder layer.
- **Decoder masked self-attention** — same, with a mask blocking rightward attention.
- **Encoder-decoder cross-attention** — Q from the previous decoder layer, K and V from the encoder output.

**Feed-forward network:** $\mathrm{FFN}(x) = \max(0, xW_1 + b_1) W_2 + b_2$. Applied independently at each position. Inner dim $d_{ff} = 2048$ (base), outer $d_{model} = 512$.

**Embeddings:** shared weight matrix between input embeddings, output embeddings, and the pre-softmax projection. Multiplied by $\sqrt{d_{model}}$ in the embedding layers.

### Complexity comparison (Table 1)

| Layer type | Complexity per layer | Sequential ops | Max path length |
| :--- | :--- | :--- | :--- |
| Self-Attention | $O(n^2 \cdot d)$ | $O(1)$ | $O(1)$ |
| Recurrent | $O(n \cdot d^2)$ | $O(n)$ | $O(n)$ |
| Convolutional | $O(k \cdot n \cdot d^2)$ | $O(1)$ | $O(\log_k n)$ |
| Self-Attention (restricted) | $O(r \cdot n \cdot d)$ | $O(1)$ | $O(n/r)$ |

Self-attention has the **shortest path length between any two positions ($O(1)$)** — the main theoretical reason it learns long-range dependencies efficiently. It is also faster than recurrent layers when $n < d$, typical for sentence-level MT with word-piece or BPE vocabularies.

### Training

- **Data:** WMT 2014 En-De (4.5M sentence pairs, BPE, ~37K shared vocabulary); WMT 2014 En-Fr (36M sentences, word-piece, 32K vocabulary). See [[wmt-2014]].
- **Batches:** ~25K source + 25K target tokens per batch, bucketed by approximate sequence length.
- **Hardware:** single machine, 8× NVIDIA P100 GPUs. Base model: 100K steps / 12 hours. Big model: 300K steps / 3.5 days.
- **Optimizer:** Adam ($\beta_1=0.9$, $\beta_2=0.98$, $\epsilon = 10^{-9}$) with a custom learning rate schedule: $\text{lrate} = d_{model}^{-0.5} \cdot \min(\text{step}^{-0.5}, \text{step} \cdot \text{warmup}^{-1.5})$, warmup = 4000 steps. Linear warmup, inverse-sqrt decay.
- **Regularization:** residual dropout ($P=0.1$ base, 0.3 big), label smoothing ($\epsilon_{ls}=0.1$). Label smoothing hurts perplexity but improves BLEU.

## Results

### WMT 2014 En-De (Table 2)

| Model | BLEU | Training FLOPs |
| :--- | :--- | :--- |
| ConvS2S (ensemble) | 26.36 | $7.7 \times 10^{19}$ |
| MoE | 26.03 | $2.0 \times 10^{19}$ |
| Transformer (base) | 27.3 | $3.3 \times 10^{18}$ |
| **Transformer (big)** | **28.4** | $2.3 \times 10^{19}$ |

### WMT 2014 En-Fr (Table 2)

| Model | BLEU | Training FLOPs |
| :--- | :--- | :--- |
| ConvS2S (ensemble) | 41.29 | $1.2 \times 10^{21}$ |
| GNMT + RL (ensemble) | 41.16 | $1.1 \times 10^{21}$ |
| Transformer (base) | 38.1 | $3.3 \times 10^{18}$ |
| **Transformer (big)** | **41.8** | $2.3 \times 10^{19}$ |

The efficiency story is striking: the Transformer (big) reaches the En-Fr SOTA using roughly 2% of the compute of the prior best ensemble.

### English constituency parsing (Table 4)

A 4-layer Transformer with $d_{model}=1024$ trained on the WSJ portion of Penn Treebank (~40K sentences) achieves **91.3 F1** (WSJ-only) and **92.7 F1** (semi-supervised) on section 23. Beats all prior published models except the Recurrent Neural Network Grammar (Dyer et al. 2016). Demonstrates the Transformer generalizes well beyond MT.

## Discussion

### Ablations (Table 3)

The paper ablates individual design choices on WMT'14 En-De dev set:

- **Row (A) — attention heads.** Single-head ($h=1$) is 0.9 BLEU worse than $h=8$. Quality also drops off with too many heads ($h=32$). There is an optimum, not a monotonic relationship.
- **Row (B) — key size $d_k$.** Reducing $d_k$ hurts quality. The authors explicitly note: "this suggests that determining compatibility is not easy and that a more sophisticated compatibility function than dot product may be beneficial." An honestly acknowledged limitation.
- **Row (C) — model size.** Bigger $d_{model}$ and $d_{ff}$ both help. More layers ($N$) help up to ~8.
- **Row (D) — dropout.** Essential — zero dropout is 1.2 BLEU worse than 0.1.
- **Row (E) — positional encoding.** Learned positional embeddings give nearly identical BLEU to sinusoidal (the paper chose sinusoidal for *potential* length extrapolation but does not demonstrate this benefit empirically).

### Authors' own framing

From the conclusion: "We are excited about the future of attention-based models and plan to apply them to other tasks. We plan to extend the Transformer to problems involving input and output modalities other than text and to investigate local, restricted attention mechanisms to efficiently handle large inputs and outputs such as images, audio and video. Making generation less sequential is another research goals of ours."

In retrospect this reads as understated. Nearly every prediction came true within 3–5 years: vision transformers (ViT 2020), audio transformers (wav2vec 2020), video transformers, and a whole research area on efficient restricted attention.

### Attention visualizations

The appendix shows individual attention heads at layer 5/6 learning distinct interpretable patterns — the origin of the "attention is interpretable" narrative that dominated transformer interpretability research for years. See the Figures section below.

## Figures

**Figure 1 — The Transformer model architecture:**

![[1706.03762-fig1-transformer-architecture.pdf]]

**Figure 2 — Scaled dot-product attention (left) and multi-head attention (right):**

![[1706.03762-fig2-attention-mechanisms.pdf]]

**Long-distance dependency resolution** — heads at layer 5 completing the phrasal verb "making ... more difficult" across intervening tokens:

![[1706.03762-long-distance-making-1.pdf]]

![[1706.03762-long-distance-making-2.pdf]]

**Anaphora resolution** — heads 5 and 6 sharply attending from the pronoun "its" to its antecedent:

![[1706.03762-anaphora-resolution-1.pdf]]

![[1706.03762-anaphora-resolution-2.pdf]]

**Different heads learning different syntactic/semantic patterns:**

![[1706.03762-attention-heads-1.pdf]]

![[1706.03762-attention-heads-2.pdf]]

## Historical Context

This paper is the origin point of the transformer revolution. Every modern LLM — BERT, GPT, T5, Llama, Claude, Gemini — traces its architectural lineage here.

**Immediate descendants (2018–2020):**
- **Encoder-only** → BERT (2018), RoBERTa (2019), DeBERTa (2020) — pretrained with masked language modeling, used for classification, retrieval, embeddings.
- **Decoder-only** → GPT-1 (2018), GPT-2 (2019), GPT-3 (2020), later Llama, Mistral, Claude, Gemini — pretrained with next-token prediction. **The dominant LLM pattern today.**
- **Encoder-decoder** → T5 (2019), BART (2019), mT5 (2020) — retain both stacks with text-to-text objectives.

**Downstream technical threads traced back to this paper:**
- **Efficient attention** — Longformer, Sparse Transformer, Performer, Flash Attention, Mamba. All address the $O(n^2)$ scaling limit.
- **Position encoding evolution** — relative position embeddings (Shaw 2018), RoPE (Su 2021, now dominant), ALiBi (Press 2021).
- **Architecture improvements** — pre-LN vs post-LN (Xiong 2020), RMSNorm, multi-query attention (Shazeer 2019), grouped-query attention (Ainslie 2023).
- **Scaling laws** — Kaplan 2020, Chinchilla 2022 — quantitative analyses of how transformer performance scales with data, parameters, and compute.

**Author-footnote details that became significant later:**
- **[[noam-shazeer|Noam Shazeer]]** proposed scaled dot-product attention, multi-head attention, and the parameter-free position representation. Later co-founded Character.AI.
- **[[aidan-gomez|Aidan Gomez]]** (listed as University of Toronto, work performed at Google Brain) later co-founded Cohere.
- **[[illia-polosukhin|Illia Polosukhin]]** co-founded NEAR Protocol.
- **[[ashish-vaswani|Ashish Vaswani]]** with Polosukhin designed and implemented the first Transformer models.
- Listing order among the eight equally-contributing authors is explicitly random.

## Provenance

- **Source file:** `raw/papers/1706.03762v7-attention-is-all-you-need.tar.gz` (arXiv v7 of 1706.03762, revised June 2023; originally submitted June 2017).
- **Source format:** LaTeX tarball. Read directly from the `.tex` files (`ms.tex`, `introduction.tex`, `background.tex`, `model_architecture.tex`, `why_self_attention.tex`, `training.tex`, `results.tex`, `visualizations.tex`) — no PDF compilation step needed for the prose.
- **Figures 1–2:** drawn inline with TikZ/LaTeX in `model_architecture.tex`, not separately included in the source tarball. Rasterized from the compiled arXiv PDF via `pdftoppm` and stored in `raw/assets/` as `1706.03762-fig1-transformer-architecture.pdf` and `1706.03762-fig2-attention-mechanisms.pdf`.
- **Figures 3–5 (attention visualizations):** copied directly from `vis/*.pdf` inside the tarball and renamed to the `1706.03762-*` convention.
- **License / reproduction note:** the arXiv v7 tarball adds the notice *"Provided proper attribution is provided, Google hereby grants permission to reproduce the tables and figures in this paper solely for use in journalistic or scholarly works."* This grants reproduction rights for the **tables and figures only** — the paper text / LaTeX source remains under standard copyright. The 8 figures are committed to the repo under a narrow `!raw/assets/1706.03762-*` gitignore exception; the tarball itself stays gitignored.

## Related

- [[transformer]]
- [[self-attention]]
- [[scaled-dot-product-attention]]
- [[multi-head-attention]]
- [[positional-encoding]]
- [[encoder-decoder-architecture]]
- [[attention-mechanism]]
- [[ashish-vaswani]]
- [[noam-shazeer]]
- [[aidan-gomez]]
- [[illia-polosukhin]]
- [[google-brain]]
- [[wmt-2014]]
