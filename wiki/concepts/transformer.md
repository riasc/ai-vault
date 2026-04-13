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

The **Transformer** is a sequence transduction neural network architecture based entirely on [[attention-mechanism|attention]], with no recurrence and no convolution. Introduced by Vaswani et al. in [[summary-attention-is-all-you-need|Attention Is All You Need]] (2017), it is the foundational architecture for essentially all modern large language models.

## Architecture

The original Transformer is an [[encoder-decoder-architecture]] with N=6 stacked identical layers on each side.

**Encoder layer:**
1. [[multi-head-attention|Multi-head self-attention]] (residual + layer norm)
2. Position-wise feed-forward network (residual + layer norm)

**Decoder layer:**
1. Masked [[multi-head-attention|multi-head self-attention]] (residual + layer norm)
2. [[multi-head-attention|Multi-head]] encoder-decoder attention (residual + layer norm)
3. Position-wise feed-forward network (residual + layer norm)

The masking in decoder self-attention prevents positions from attending to later positions, preserving the auto-regressive property. Every sub-layer is wrapped as `LayerNorm(x + Sublayer(x))` so residual connections flow end-to-end.

## Key hyperparameters

| Parameter | Base | Big |
| :--- | :--- | :--- |
| N (layers) | 6 | 6 |
| d_model | 512 | 1024 |
| d_ff (FFN inner dim) | 2048 | 4096 |
| h (attention heads) | 8 | 16 |
| d_k = d_v | 64 | 64 |
| Dropout | 0.1 | 0.3 |
| Parameters | 65M | 213M |

## Inputs

- **Token embeddings** — learned, of dimension d_model. Multiplied by √d_model. The input-embedding, output-embedding, and pre-softmax projection matrices share weights.
- **[[positional-encoding]]** — sinusoidal, summed with token embeddings at the bottom of the encoder and decoder stacks.

## Why it matters

- **Parallelizable training** — unlike RNNs, every position in a sequence can be processed in parallel. This is the practical reason Transformers scale to trillion-parameter models on modern hardware.
- **Short path between positions** — self-attention gives O(1) max path length between any two positions (vs O(n) for RNNs), making long-range dependencies easier to learn.
- **Foundation of the modern LLM era** — BERT, GPT, T5, Llama, Claude, Gemini, and essentially every large language model since 2018 are variants of this architecture.

## Architectural descendants

- **Encoder-only** (BERT, RoBERTa, DeBERTa) — drop the decoder, use masked language modeling as the pretraining objective.
- **Decoder-only** (GPT, Llama, Mistral, Claude) — drop the encoder, use next-token prediction with a causal mask throughout.
- **Encoder-decoder** (T5, BART, mT5) — keep both stacks, typically with a unified text-to-text objective.

## Figures

**Figure 1 — The Transformer model architecture:**

![[1706.03762-fig1-transformer-architecture.pdf]]

**Figure 2 — Scaled dot-product attention (left) and multi-head attention (right):**

![[1706.03762-fig2-attention-mechanisms.pdf]]

## Sources

- [[summary-attention-is-all-you-need]]
