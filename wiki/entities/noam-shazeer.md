---
type: entity
entity_type: person
title: "Noam Shazeer"
sources:
  - [[summary-attention-is-all-you-need]]
related:
  - [[transformer]]
  - [[scaled-dot-product-attention]]
  - [[multi-head-attention]]
  - [[google-brain]]
created: 2026-04-13
updated: 2026-04-13
---

# Noam Shazeer

## What / Who

Researcher, formerly at [[google-brain|Google Brain]]. Co-author of [[summary-attention-is-all-you-need|Attention Is All You Need]] (2017) and numerous other foundational papers on scaling, efficiency, and conditional computation in deep learning.

## Significance

Per the author footnote of the Transformer paper, Shazeer **proposed [[scaled-dot-product-attention]], [[multi-head-attention]], and the parameter-free position representation** — arguably the three key technical innovations of the paper. The scaling by $\sqrt{d_k}$, which is one of the paper's highest-ROI contributions, is specifically attributed to him.

Shazeer's wider body of work is a through-line in modern LLM architecture: mixture-of-experts, multi-query attention (MQA), T5 design choices, and numerous scaling and efficiency tricks.

## Timeline / Notable Work

- **2017** — Co-author of *Outrageously Large Neural Networks* (Shazeer et al.) — the sparsely-gated mixture-of-experts layer that later became foundational for Switch Transformer, Mixtral, and other MoE models.
- **2017** — Co-author of *Attention Is All You Need*. Credited with scaled dot-product attention and multi-head attention.
- **2019** — Proposed **multi-query attention (MQA)**, a significant efficiency improvement that reduces KV-cache memory during inference by sharing keys/values across heads. The precursor to grouped-query attention (GQA), now standard in Llama 2+, Mistral, and most modern LLMs.
- **Later** — Co-founded **Character.AI**.

## Relationships

- [[transformer]] — proposed three of its key technical components.
- [[scaled-dot-product-attention]] — proposed the $\sqrt{d_k}$ scaling and the overall formulation.
- [[multi-head-attention]] — proposed the parallel-head structure.
- [[google-brain]] — institutional home at time of publication.

## Sources

- [[summary-attention-is-all-you-need]]
