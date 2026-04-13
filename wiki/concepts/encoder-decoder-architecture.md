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

The **encoder-decoder architecture** is the dominant structure for sequence transduction tasks such as machine translation, summarization, and speech recognition.

- The **encoder** maps an input sequence `(x_1, ..., x_n)` to a sequence of continuous representations `(z_1, ..., z_n)`.
- The **decoder** generates an output sequence `(y_1, ..., y_m)` one element at a time, consuming previously generated symbols auto-regressively.

## Historical lineage (pre-Transformer)

The common pattern before 2017 was a *recurrent or convolutional* encoder and decoder, optionally *augmented* with [[attention-mechanism|attention]]:

- **RNN encoder-decoder** (Sutskever et al. 2014; Cho et al. 2014) — both stacks are recurrent networks (LSTM or GRU).
- **Bahdanau attention** (2014) — adds an attention layer so the decoder can focus on different encoder positions at each output step.
- **ByteNet** (Kalchbrenner et al. 2017) — convolutional encoder-decoder.
- **ConvS2S** (Gehring et al. 2017) — convolutional encoder-decoder with attention.

## Transformer encoder-decoder

The [[transformer]] keeps the encoder-decoder pattern but replaces recurrence and convolution entirely with [[self-attention]] and feed-forward layers. Its three attention roles:

1. **Encoder self-attention** — every encoder position attends to every other encoder position.
2. **Decoder masked self-attention** — each decoder position attends to earlier decoder positions only.
3. **Encoder-decoder cross-attention** — decoder queries attend over encoder keys/values, the "classic" attention role carried over from Bahdanau-style models.

See the architecture diagram: `raw/assets/1706.03762-fig1-transformer-architecture.pdf`.

## Descendant variants (post-Transformer)

- **Encoder-only** (BERT, RoBERTa, DeBERTa) — drop the decoder; use a masked-language-modeling objective for pretraining.
- **Decoder-only** (GPT, Llama, Mistral, Claude) — drop the encoder; use autoregressive next-token prediction. This is the dominant LLM pattern today.
- **Encoder-decoder** (T5, BART, mT5) — retain both stacks, typically with text-to-text objectives.

## Sources

- [[summary-attention-is-all-you-need]]
