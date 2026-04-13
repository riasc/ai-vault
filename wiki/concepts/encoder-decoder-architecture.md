---
type: concept
title: "Encoder-Decoder Architecture"
aliases: [seq2seq, sequence-to-sequence, encoder decoder]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[transformer]]
  - [[self-attention]]
  - [[attention-mechanism]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Encoder-Decoder Architecture

## Definition

The **encoder-decoder architecture** splits sequence transduction into two stages. The **encoder** maps an input sequence $(x_1, \ldots, x_n)$ to a sequence of continuous representations $(z_1, \ldots, z_n)$. The **decoder** then generates an output sequence $(y_1, \ldots, y_m)$ one element at a time, conditioning on those representations auto-regressively.

## Intuition

Sequence transduction tasks — machine translation, summarization, speech recognition — have differing input and output lengths, vocabularies, and sometimes modalities. Jamming everything through a single stack forces the model to do "understanding" and "generating" simultaneously. Splitting into encoder and decoder lets each stage specialize:

- The encoder can attend bidirectionally and build rich contextual representations.
- The decoder can generate left-to-right (auto-regressively), attending both to its own partial output and to the full encoder representation via **cross-attention**.

The split is the natural home for bidirectional-vs-causal attention patterns and is mirrored in how pretraining objectives diverged (masked LM for encoders, next-token prediction for decoders).

## Formulation

Written schematically:

$$\text{encoder: } (x_1, \ldots, x_n) \xrightarrow{\text{Encoder}} (z_1, \ldots, z_n)$$

$$\text{decoder: } y_t = \text{Decoder}(y_{<t}, z_{1:n})$$

At each decoder step $t$, the model consumes:
- The previously generated tokens $y_{<t}$ (self-attention, causal mask)
- The full encoder output $z_{1:n}$ (cross-attention from decoder queries to encoder keys/values)

Training is typically done with teacher forcing and cross-entropy on the next-token prediction at every position of the target sequence.

## Variants

- **Encoder-only** (BERT, RoBERTa, DeBERTa, ELECTRA) — drop the decoder. Pretrained with masked language modeling (MLM). Used for classification, retrieval, and embedding tasks.
- **Decoder-only** (GPT, Llama, Mistral, Claude, Gemini) — drop the encoder. Pretrained with next-token prediction and a causal mask throughout. **The dominant LLM pattern today.**
- **Encoder-decoder** (original Transformer, T5, BART, mT5, Flan-T5) — retain both stacks. Typically pretrained with span corruption or denoising objectives; fine-tuned for conditional generation tasks.
- **Prefix LM** (UniLM, XLNet variants) — hybrid: one stack with bidirectional attention over a "prefix" and causal attention over the rest.

## Tradeoffs

- **Parameter count.** Encoder-decoder has twice the stack depth for the same per-layer size, which means more parameters. Decoder-only reuses the same stack for "understanding" and "generating," which is simpler and scales more predictably.
- **Scaling properties.** Decoder-only models have shown cleaner scaling laws and easier training at large sizes, which is a big part of why they won the LLM race post-2020. Encoder-decoder models often match or exceed decoder-only on fine-tuned tasks but are less dominant in the pretrained-zero-shot paradigm.
- **Conditional generation vs open-ended generation.** Encoder-decoder is natural for tasks with a well-defined input to condition on (translation, summarization, QA). Decoder-only turns out to handle these via in-context learning and prompting, trading architectural specialization for flexibility.
- **Inference cost.** Decoder-only models have a larger KV cache (one per layer for the full generated sequence), but the encoder's output in an encoder-decoder model must still be cached — so the difference is less dramatic than it first appears.

## History & Lineage

**Precursors (pre-Transformer):**
- **RNN encoder-decoder** — Sutskever et al. 2014, Cho et al. 2014. Both stacks are recurrent networks (LSTM or GRU).
- **Bahdanau attention** — Bahdanau, Cho, Bengio 2014. Adds an attention layer so the decoder can focus on different encoder positions at each output step. The single most important pre-Transformer addition.
- **ConvS2S** — Gehring et al. 2017. Convolutional encoder-decoder with attention.
- **ByteNet** — Kalchbrenner et al. 2017. Convolutional encoder-decoder.

**The Transformer** [[summary-attention-is-all-you-need]] keeps the encoder-decoder pattern but replaces recurrence and convolution with [[self-attention]] and position-wise feed-forward layers.

**Post-Transformer evolution:**
- **2018** — GPT-1 (decoder-only), BERT (encoder-only). The encoder-decoder split becomes explicit in how pretraining diverges.
- **2019** — T5 (encoder-decoder, text-to-text). Argues everything is text-to-text.
- **2020** — GPT-3 (decoder-only, 175B). Decoder-only wins the mainstream LLM race.
- **2022+** — Llama, Mistral, Claude, Gemini are all decoder-only. Encoder-only survives in retrieval/embeddings; encoder-decoder survives in specialized translation and conditional-generation settings.

## Figures

The architecture diagram makes the encoder (left) and decoder (right) stacks — and the cross-attention link between them — clear:

![[1706.03762-fig1-transformer-architecture.pdf]]

## Sources

- [[summary-attention-is-all-you-need]]
