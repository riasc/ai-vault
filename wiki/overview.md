---
type: overview
title: AI/ML Research — Overview
updated: 2026-04-13
---

# Overview

This wiki is a personal, LLM-maintained knowledge base for AI/ML research, recent technologies, and learning material. It follows the Karpathy LLM Wiki Stack pattern: the human curates `raw/` sources, the LLM compiles them into structured, interlinked `wiki/` pages, and `CLAUDE.md` defines the workflows.

## Current state

The wiki currently covers the foundation of modern sequence modeling: the [[transformer]] architecture from [[summary-attention-is-all-you-need|Attention Is All You Need]] (Vaswani et al., 2017). The seven concept pages around attention — [[attention-mechanism]], [[self-attention]], [[scaled-dot-product-attention]], [[multi-head-attention]], [[positional-encoding]], [[encoder-decoder-architecture]], and the [[transformer]] itself — form a tight cluster that every subsequent LLM paper will extend.

**Depth:** 1 source summary, 7 concept pages, 6 entity pages.

## Natural next directions

- **Encoder-only descendants** — BERT, RoBERTa, DeBERTa.
- **Decoder-only descendants** — GPT series, Llama, Mistral, Claude, Gemini.
- **Position-encoding evolution** — relative position embeddings, RoPE, ALiBi.
- **Efficient attention** — Flash Attention, sparse/linear attention variants, state-space models (Mamba, S4).
- **Scaling laws** — Kaplan et al. 2020, Chinchilla (Hoffmann et al. 2022).

This page is revised after each major ingest to reflect the wiki's high-level synthesis.

## Reference

This vault follows the [Karpathy LLM Wiki Stack](https://github.com/ScrapingArt/Karpathy-LLM-Wiki-Stack) blueprint, based on Andrej Karpathy's [original gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
