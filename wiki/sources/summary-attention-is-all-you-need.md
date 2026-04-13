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

**Vaswani, Shazeer, Parmar, Uszkoreit, Jones, Gomez, Kaiser, Polosukhin — NeurIPS 2017.**

Introduces the [[transformer]], the first sequence transduction model built entirely on [[attention-mechanism|attention]], discarding recurrence and convolution.

## Abstract (paraphrase)

Dominant sequence transduction models use RNN- or CNN-based encoder-decoders, often augmented with attention. This paper proposes the **Transformer**, a purely attention-based architecture that is simpler, more parallelizable, and faster to train. It achieves **28.4 BLEU** on WMT 2014 English-to-German (+2 BLEU over prior SOTA, including ensembles) and **41.8 BLEU** on English-to-French after 3.5 days of training on 8 P100 GPUs — a small fraction of the cost of prior SOTA models. The Transformer also generalizes well: applied to English constituency parsing (WSJ, Penn Treebank), it outperforms all prior published models except the RNNG of Dyer et al.

## Key contributions

1. **The Transformer architecture** — a purely attention-based [[encoder-decoder-architecture]]. See [[transformer]].
2. **[[self-attention|Self-attention]] as a first-class layer type** — relating all positions in a sequence in O(1) sequential ops and O(1) maximum path length between any two positions, unlike recurrent (O(n)/O(n)) or convolutional (O(1)/O(log_k n)) layers.
3. **[[scaled-dot-product-attention|Scaled dot-product attention]]** — `softmax(QK^T / √d_k) V`. The √d_k scaling prevents softmax saturation when d_k is large.
4. **[[multi-head-attention|Multi-head attention]]** — h=8 parallel heads with d_k = d_v = d_model/h = 64, projecting into different learned subspaces, concatenated and linearly projected back.
5. **Sinusoidal [[positional-encoding]]** — `PE(pos, 2i) = sin(pos / 10000^{2i/d_model})` (cos for odd i), added to input embeddings. Learned positional embeddings give nearly identical results; sinusoidal may extrapolate to longer sequences.

## Architecture (Figure 1)

**Encoder:** stack of N=6 identical layers. Each layer has two sub-layers:
1. Multi-head self-attention
2. Position-wise feed-forward network

Each sub-layer is wrapped with a residual connection and layer normalization: `LayerNorm(x + Sublayer(x))`. Output dimension d_model = 512.

**Decoder:** stack of N=6 identical layers. Each layer adds a third sub-layer: multi-head attention over the encoder output (cross-attention). The decoder's self-attention is *masked* (illegal logits set to −∞) to prevent positions from attending to subsequent positions, preserving the auto-regressive property.

**Attention layers are used in three ways:**
- **Encoder self-attention** — queries, keys, values all from the previous encoder layer.
- **Decoder masked self-attention** — same, but with a mask blocking rightward attention.
- **Encoder-decoder cross-attention** — queries from the previous decoder layer, keys and values from the encoder output.

**Position-wise FFN:** `FFN(x) = max(0, xW_1 + b_1) W_2 + b_2`. Inner dim d_ff = 2048, outer d_model = 512. Equivalent to two 1×1 convolutions.

**Embeddings:** shared weight matrix between input embeddings, output embeddings, and the pre-softmax projection. Multiplied by √d_model in the embedding layers.

![[1706.03762-fig1-transformer-architecture.pdf]]

**Figure 2** — Scaled dot-product attention (left) and multi-head attention (right):

![[1706.03762-fig2-attention-mechanisms.pdf]]

## Complexity comparison (Table 1)

| Layer type | Complexity per layer | Sequential ops | Max path length |
| :--- | :--- | :--- | :--- |
| Self-Attention | O(n² · d) | O(1) | O(1) |
| Recurrent | O(n · d²) | O(n) | O(n) |
| Convolutional | O(k · n · d²) | O(1) | O(log_k n) |
| Self-Attention (restricted) | O(r · n · d) | O(1) | O(n/r) |

The core argument: self-attention has the **shortest path length between any two positions (O(1))**, which is the main reason it learns long-range dependencies efficiently. It's also faster than recurrent layers when n < d — typical for sentence-level MT with wordpiece/BPE vocabularies.

## Training details

- **Data:** WMT 2014 En-De (4.5M sentence pairs, BPE, ~37K shared vocabulary); WMT 2014 En-Fr (36M sentences, word-piece, 32K vocabulary). See [[wmt-2014]].
- **Batches:** ~25K source + 25K target tokens per batch, bucketed by approximate sequence length.
- **Hardware:** single machine, 8× NVIDIA P100. Base model: 100K steps / 12 hours. Big model: 300K steps / 3.5 days.
- **Optimizer:** Adam (β1=0.9, β2=0.98, ε=1e-9) with a custom learning rate schedule: `lrate = d_model^{-0.5} · min(step^{-0.5}, step · warmup_steps^{-1.5})`, warmup_steps = 4000. Linear warmup, inverse-sqrt decay.
- **Regularization:** residual dropout (P=0.1 base, 0.3 big), label smoothing (ε_ls = 0.1) — hurts perplexity, improves BLEU.

## Results

### WMT 2014 EN-DE (Table 2)

| Model | BLEU | Training FLOPs |
| :--- | :--- | :--- |
| ConvS2S (ensemble) | 26.36 | 7.7×10¹⁹ |
| MoE | 26.03 | 2.0×10¹⁹ |
| Transformer (base) | 27.3 | 3.3×10¹⁸ |
| **Transformer (big)** | **28.4** | 2.3×10¹⁹ |

### WMT 2014 EN-FR (Table 2)

| Model | BLEU | Training FLOPs |
| :--- | :--- | :--- |
| ConvS2S (ensemble) | 41.29 | 1.2×10²¹ |
| GNMT + RL (ensemble) | 41.16 | 1.1×10²¹ |
| Transformer (base) | 38.1 | 3.3×10¹⁸ |
| **Transformer (big)** | **41.8** | 2.3×10¹⁹ |

The efficiency story is striking: the Transformer (big) reaches the En-Fr SOTA using roughly 2% of the compute of the prior best ensemble.

### Ablations (Table 3, partial)

- **Heads (row A):** h=1 is 0.9 BLEU worse than h=8; quality also drops off with too many heads (h=32).
- **Key size (row B):** reducing d_k hurts quality — suggests the dot-product compatibility function is not trivially expressive.
- **Model size (row C):** bigger d_model and d_ff both help. More layers (N) help up to ~8.
- **Dropout (row D):** essential — zero dropout is 1.2 BLEU worse than 0.1.
- **Positional encoding (row E):** learned positional embeddings give nearly identical BLEU to sinusoidal. Sinusoidal was chosen for potential length extrapolation.

### English constituency parsing (Table 4)

A 4-layer Transformer with d_model=1024 trained on the WSJ portion of Penn Treebank (~40K sentences) achieves **91.3 F1** (WSJ-only) and **92.7 F1** (semi-supervised) on section 23. Beats all prior published models except the Recurrent Neural Network Grammar (Dyer et al. 2016). Demonstrates the Transformer generalizes well beyond MT — a foreshadowing of its eventual universality.

## Attention visualizations (appendix)

The appendix shows individual attention heads at layer 5/6 learning distinct interpretable patterns.

**Long-distance dependencies** — a head attends from `making` to `more difficult`, completing the phrasal verb across intervening tokens:

![[1706.03762-long-distance-making-1.pdf]]

![[1706.03762-long-distance-making-2.pdf]]

**Anaphora resolution** — heads 5 and 6 sharply attend from the pronoun `its` to its antecedent:

![[1706.03762-anaphora-resolution-1.pdf]]

![[1706.03762-anaphora-resolution-2.pdf]]

**Syntactic / semantic structure** — different heads learn to highlight different aspects of sentence structure:

![[1706.03762-attention-heads-1.pdf]]

![[1706.03762-attention-heads-2.pdf]]

These visualizations originated the "attention is interpretable" narrative that dominated transformer interpretability research for years.

## Historical context

This paper is the origin point of the transformer revolution. Every modern LLM — BERT, GPT, T5, Llama, Claude, Gemini — traces its architectural lineage to this paper:

- **Encoder-only** variants → BERT, RoBERTa, DeBERTa
- **Decoder-only** variants → GPT, Llama, Mistral, Claude, Gemini
- **Encoder-decoder** variants → T5, BART, mT5

Author footnote details that became significant later:
- **[[noam-shazeer|Noam Shazeer]]** proposed scaled dot-product attention, multi-head attention, and the parameter-free position representation. Later co-founded Character.AI.
- **[[aidan-gomez|Aidan Gomez]]** (listed as University of Toronto, work performed at Google Brain) later co-founded Cohere.
- **[[illia-polosukhin|Illia Polosukhin]]** co-founded NEAR Protocol.
- **[[ashish-vaswani|Ashish Vaswani]]** with Polosukhin designed and implemented the first Transformer models.
- Listing order among the eight equally-contributing authors is explicitly random.

## Provenance notes

- **Source:** `raw/papers/1706.03762v7-attention-is-all-you-need.tar.gz` (arXiv v7 of 1706.03762, revised June 2023; originally submitted June 2017).
- **Source format:** LaTeX tarball, read directly from `.tex` files (ms, introduction, background, model_architecture, why_self_attention, training, results, visualizations).
- **Figures 1–2:** drawn inline with TikZ/LaTeX, not separately included in the source tarball. Rasterized from the compiled arXiv PDF and stored in `raw/assets/` as `1706.03762-fig1-transformer-architecture.pdf` and `1706.03762-fig2-attention-mechanisms.pdf`.
- **Figures 3–5 (attention visualizations):** copied directly from `vis/*.pdf` inside the tarball.
- The v7 revision adds a notice: "Provided proper attribution is provided, Google hereby grants permission to reproduce the tables and figures in this paper solely for use in journalistic or scholarly works."

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
