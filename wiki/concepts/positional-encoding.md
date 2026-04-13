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

## Definition

**Positional encoding** injects token-order information into an otherwise permutation-invariant [[self-attention]] mechanism by adding position-dependent vectors to token embeddings.

## Intuition

[[self-attention|Self-attention]] treats its input as a *set* of (key, value) pairs — nothing in the mechanism distinguishes "the cat sat on the mat" from "on the mat sat the cat." To recover word order, the [[transformer]] adds a fixed-or-learned vector to each token embedding that encodes where that token is in the sequence. The attention layers then see a signal that is jointly a function of *what* the token is and *where* it is.

Because the encoding is added (not concatenated), it uses the same dimensionality as the token embedding, and the model learns to pull apart content and position internally.

## Formulation

The original Transformer uses **sinusoidal positional encoding**:

$$PE_{(pos, 2i)}   = \sin(pos / 10000^{2i / d_{model}})$$
$$PE_{(pos, 2i+1)} = \cos(pos / 10000^{2i / d_{model}})$$

where $pos$ is the position and $i$ is the dimension index. Each dimension is a sinusoid with wavelengths forming a geometric progression from $2\pi$ to $10000 \cdot 2\pi$.

**Rationale:** for any fixed offset $k$, $PE_{pos+k}$ can be expressed as a linear function of $PE_{pos}$. The authors hypothesized this would let the model easily learn to attend by *relative* position.

The encoding is summed with the token embedding at the bottom of both the encoder and decoder stacks:

$$\text{input}_{pos} = \text{TokenEmbed}(x_{pos}) + PE_{pos}$$

## Variants

- **Sinusoidal (fixed)** — the original Transformer choice. No learned parameters, potentially extrapolates to unseen sequence lengths.
- **Learned absolute embeddings** — used by BERT. A learned lookup table indexed by position. Simple and effective, but cannot extrapolate beyond the maximum training length.
- **Relative position embeddings** (Shaw et al. 2018, T5) — encode the *difference* between two positions rather than absolute positions. More robust to sequence length variation.
- **Rotary Position Embedding (RoPE)** (Su et al. 2021) — rotates query and key vectors by an angle proportional to position. **Dominant choice in modern LLMs** (Llama, Mistral, PaLM, Qwen, etc.). Encodes relative position through the inner product, extrapolates reasonably well.
- **ALiBi** (Press et al. 2021) — adds a distance-based bias directly to attention logits. No explicit position vectors. Used in BLOOM and some long-context variants.
- **No positional encoding at all** — surprisingly, decoder-only transformers with causal masking can learn implicit position from the mask alone. See Haviv et al. 2022.

## Tradeoffs

- **Sinusoidal vs learned:** empirically nearly identical on in-distribution data. Row (E) of Table 3 in the Transformer paper shows BLEU of 4.92 (sinusoidal) vs 4.92 (learned) perplexity on WMT'14 En-De dev — a *tie*. The authors chose sinusoidal for *potential* length extrapolation, but the paper does not demonstrate this benefit empirically.
- **Absolute vs relative:** absolute encodings don't extrapolate well beyond training length. Relative / rotary variants are more robust and have largely displaced absolute encodings in new models.
- **Adding vs concatenating:** adding (the Transformer's choice) is cheaper and works, but forces content and position into the same subspace. Some research has argued for more structured separations.
- **Long-context performance** is especially sensitive to PE choice — this is where RoPE and ALiBi pulled ahead of sinusoidal and learned-absolute.

## History & Lineage

**Source paper:** [[summary-attention-is-all-you-need|Vaswani et al. 2017]] introduced sinusoidal encoding and compared against learned positional embeddings from Gehring et al. (ConvS2S, 2017).

**Evolution:**
- 2018 — Shaw et al., relative position encoding.
- 2018 — BERT, learned absolute embeddings (simpler than sinusoidal, same effectiveness in practice).
- 2019 — T5 uses simplified relative position biases.
- 2021 — RoPE (Su et al.), now the dominant choice in modern LLMs.
- 2021 — ALiBi (Press et al.), linear biases on attention logits.
- 2022 — Haviv et al., showing causal masking alone can implicitly encode position.

Position encoding has turned out to be a surprisingly active research area — the original sinusoidal choice was not the last word, and modern long-context LLMs depend heavily on getting this right.

## Sources

- [[summary-attention-is-all-you-need]]
