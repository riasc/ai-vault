---
type: concept
title: "Positional Encoding"
aliases: [positional embeddings, position encoding]
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[transformer]]
  - [[self-attention]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Positional Encoding

Because [[self-attention]] is permutation-invariant — it treats the input as a set, not a sequence — the [[transformer]] must inject information about token positions explicitly. **Positional encodings** are vectors added to the token embeddings at the bottom of the encoder and decoder stacks, giving the model a signal about the order of tokens.

## Sinusoidal encoding (original Transformer)

```
PE(pos, 2i)   = sin(pos / 10000^{2i/d_model})
PE(pos, 2i+1) = cos(pos / 10000^{2i/d_model})
```

Each dimension of the encoding is a sinusoid, with wavelengths forming a geometric progression from 2π to 10000·2π.

**Rationale:** for any fixed offset k, `PE(pos+k)` can be expressed as a linear function of `PE(pos)`. The authors hypothesized this would let the model easily learn to attend by relative position.

Dimensionality matches the token embedding (d_model) so the two can be summed directly.

## Learned vs. sinusoidal

The authors compared sinusoidal encodings to learned positional embeddings in row (E) of Table 3 and found **nearly identical BLEU**. They chose sinusoidal because it *might* extrapolate to sequence lengths not seen during training — a hypothesis, not a demonstrated result in the paper.

## Later developments

*(Noted here for cross-referencing; not covered in the source paper.)*

- **Learned absolute embeddings** — used by BERT.
- **Relative position embeddings** — Shaw et al. 2018, T5.
- **RoPE (Rotary Position Embedding)** — Su et al. 2021. Now the dominant choice in modern LLMs (Llama, Mistral, etc.).
- **ALiBi** — Press et al. 2021. Adds a distance-based bias directly to attention logits.

## Sources

- [[summary-attention-is-all-you-need]]
