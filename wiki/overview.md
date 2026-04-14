---
type: overview
title: AI/ML Research — Overview
updated: 2026-04-13
---

# Overview

This wiki is a personal, LLM-maintained knowledge base for AI/ML research, recent technologies, and learning material. It follows the Karpathy LLM Wiki Stack pattern: the human curates `raw/` sources, the LLM compiles them into structured, interlinked `wiki/` pages organized by a taxonomy (primitives → architectures → models → methods), and `CLAUDE.md` defines the workflows.

## Current state

The wiki currently spans **two foundational papers** that bracket the modern era of large sequence models:

- **[[summary-attention-is-all-you-need|Attention Is All You Need]]** (Vaswani et al. 2017) — the [[transformer]], built on [[self-attention]] and [[multi-head-attention]] primitives. The architectural foundation of every modern LLM.
- **[[summary-evo-2|Evo 2]]** (Brixi et al. 2026) — the first DNA foundation model that is large, multi-species, and long-context (1M tokens) simultaneously. Built on [[striped-hyena-2]], a hybrid architecture that mixes [[hyena-operator]] variants with attention to break the quadratic context bottleneck.

The two papers form a deliberate juxtaposition: a pure-attention architecture optimized for natural language (Vaswani 2017) and a hybrid post-attention architecture optimized for genomes that can be megabases long (Brixi 2026). Together they trace the arc from "attention is all you need" to "attention plus hyena for the long sequences attention can't handle."

## Concept clusters

- **Attention primitives:** [[attention-mechanism]] → [[self-attention]] / [[scaled-dot-product-attention]] / [[multi-head-attention]] / [[positional-encoding]]
- **Sequence-mixing alternatives:** [[hyena-operator]] (sub-quadratic), with state-space and linear-attention as siblings (not yet ingested)
- **Architectures:** [[transformer]] (pure attention), [[striped-hyena-2]] (multi-hybrid), [[encoder-decoder-architecture]] (the design pattern they share)
- **Models:** [[evo-2]] is the only specific model so far; [[dna-foundation-model]] is the class concept
- **Methods:** [[sparse-autoencoder]] and [[mechanistic-interpretability]] arrived with the Evo 2 ingest as the first interpretability content

**Depth:** 2 source summaries, 11 concept pages (6 primitives/arch + 2 models + 2 methods), 11 entity pages (7 people, 2 orgs, 2 datasets).

## Natural next directions

From [[reading-queue]]:

**To complete the attention story:**
- BERT (Devlin et al. 2018) — first major encoder-only descendant of the Transformer.
- Bahdanau attention (2014), Sutskever seq2seq (2014), Luong dot-product attention (2015) — the precursors that motivate the Transformer's contributions.
- LayerNorm (Ba et al. 2016) and Outrageously Large NN / MoE (Shazeer et al. 2017) — companion components from the Transformer's bibliography.

**To complete the DNA / hybrid-architecture story:**
- Evo 1 (Nguyen et al. 2024, *Science*) — the prokaryote-only predecessor.
- Hyena Hierarchy (Poli et al. 2023, ICML) — the original hyena operator paper.
- StripedHyena 2 systems paper (Ku et al. 2025, arXiv:2503.01868) — engineering details for training at 40B / 1M context.
- Nucleotide Transformer (Dalla-Torre et al. 2024) — the prior DNA foundation model baseline.
- Cunningham et al. 2023 (arXiv:2309.08600) — the foundational SAE-for-interpretability paper.

**Other directions:**
- Scaling laws (Kaplan 2020, Chinchilla 2022).
- RoPE (Su 2021), ALiBi (Press 2021) — modern positional encoding.
- Flash Attention (Dao 2022), Mamba (Gu & Dao 2023) — efficient attention and state-space alternatives.

## Reference

This vault follows the [Karpathy LLM Wiki Stack](https://github.com/ScrapingArt/Karpathy-LLM-Wiki-Stack) blueprint, based on Andrej Karpathy's [original gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
