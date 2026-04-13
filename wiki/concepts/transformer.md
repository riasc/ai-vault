---
type: concept
title: "Transformer"
aliases: [transformer architecture, vanilla transformer]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[self-attention]]
  - [[multi-head-attention]]
  - [[scaled-dot-product-attention]]
  - [[positional-encoding]]
  - [[encoder-decoder-architecture]]
  - [[attention-mechanism]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Transformer

## Definition

The **Transformer** is a sequence transduction neural network architecture built entirely on [[attention-mechanism|attention]], with no recurrence and no convolution. It is an [[encoder-decoder-architecture]] in which every position-mixing sub-layer is a form of attention.

## Intuition

Prior sequence transduction models (RNNs, LSTMs, GRUs) were inherently sequential: to compute the hidden state at position t, you must already have the state at position t−1. This precludes parallelization across positions within a training example and makes long-range dependencies hard to learn, because signals must propagate through O(n) intermediate steps. Convolutional alternatives (ByteNet, ConvS2S) parallelize but still need O(log n) or O(n) layers to connect distant positions.

The Transformer's core bet is that **pure [[self-attention]] suffices**. Every position can attend to every other position in a single layer, giving O(1) maximum path length between any two positions and trivially parallel computation across the sequence. The bet paid off: this became the foundation of every modern large language model.

## Formulation

The original Transformer uses N=6 stacked identical layers on each side of an [[encoder-decoder-architecture]].

**Encoder layer:**
1. [[multi-head-attention|Multi-head self-attention]]
2. Position-wise feed-forward network

**Decoder layer:**
1. Masked [[multi-head-attention|multi-head self-attention]]
2. [[multi-head-attention|Multi-head]] encoder-decoder cross-attention
3. Position-wise feed-forward network

Each sub-layer is wrapped as `LayerNorm(x + Sublayer(x))` — a residual connection followed by layer normalization. The masking in decoder self-attention (setting illegal softmax logits to −∞) prevents positions from attending to subsequent positions, preserving the auto-regressive property.

**Feed-forward network:** $\mathrm{FFN}(x) = \max(0, xW_1 + b_1) W_2 + b_2$. Applied independently at each position. Inner dim $d_{ff} = 2048$, outer dim $d_{model} = 512$. Equivalent to two 1×1 convolutions.

**Inputs:** token embeddings of dimension $d_{model}$, multiplied by $\sqrt{d_{model}}$ and summed with sinusoidal [[positional-encoding]]. The input embedding, output embedding, and pre-softmax projection matrices share weights.

**Hyperparameters:**

| Parameter | Base | Big |
| :--- | :--- | :--- |
| N (layers per stack) | 6 | 6 |
| $d_{model}$ | 512 | 1024 |
| $d_{ff}$ | 2048 | 4096 |
| h (attention heads) | 8 | 16 |
| $d_k = d_v$ | 64 | 64 |
| Dropout | 0.1 | 0.3 |
| Parameters | 65M | 213M |

## Variants

- **Encoder-only** (BERT, RoBERTa, DeBERTa) — drop the decoder; pretrain with masked language modeling.
- **Decoder-only** (GPT, Llama, Mistral, Claude, Gemini) — drop the encoder; pretrain with next-token prediction and a causal mask throughout. **The dominant LLM pattern today.**
- **Encoder-decoder** (T5, BART, mT5) — keep both stacks with text-to-text objectives.

## Tradeoffs

- **O(n²) compute and memory in sequence length** — the attention matrix is the dominant cost at long contexts. This is the main practical limitation and drives research on efficient attention (Flash Attention, sparse/linear attention, state-space models like Mamba).
- **Position-agnostic by default** — self-attention alone is permutation-invariant, so [[positional-encoding]] must be injected explicitly. Choice of encoding turns out to matter more than initially appreciated.
- **Training stability** — the original Transformer needs a warmup schedule, layer norm placement matters (pre-LN vs post-LN), and the model is sensitive to initialization. Not visible in the original paper but surfaced in subsequent work.

## History & Lineage

**Precursors:** RNN encoder-decoder (Sutskever 2014, Cho 2014), Bahdanau attention (2014), convolutional seq2seq (ConvS2S, ByteNet, 2017). Each made progress on parallelism or path length, but none abandoned recurrence/convolution entirely.

**The paper itself:** [[summary-attention-is-all-you-need|Attention Is All You Need]] (Vaswani et al., NeurIPS 2017).

**Descendants:** essentially every large language model since 2018. The encoder-only/decoder-only/encoder-decoder split above is the main architectural fork; within each, subsequent work has iterated on positional encoding (RoPE, ALiBi), attention efficiency (Flash Attention, MQA/GQA), normalization (pre-LN, RMSNorm), and scaling (Kaplan 2020, Chinchilla 2022).

## Figures

**Figure 1 — The Transformer model architecture:**

![[1706.03762-fig1-transformer-architecture.pdf]]

**Figure 2 — Scaled dot-product attention (left) and multi-head attention (right):**

![[1706.03762-fig2-attention-mechanisms.pdf]]

## Sources

- [[summary-attention-is-all-you-need]]
