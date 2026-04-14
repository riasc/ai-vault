---
type: concept
title: "DNA Foundation Model"
aliases: [genomic foundation model, genomic language model, DNA language model]
sources:
  - [[summary-evo-2]]
related:
  - [[evo-2]]
  - [[striped-hyena-2]]
  - [[transformer]]
  - [[self-attention]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# DNA Foundation Model

## Definition

A **DNA foundation model** (also *genomic language model*) is a large neural network trained on raw DNA sequences — typically billions to trillions of nucleotides spanning many species — to learn a probability distribution over DNA strings. Once trained, the model can be used for zero-shot tasks (scoring variant likelihoods, annotating sequences via embeddings) or generative tasks (designing novel DNA) without task-specific supervised training.

This is a *class* of models, not a specific one. Current instances include [[evo-2]], Evo 1, Nucleotide Transformer, DNABERT, GenSLM, and various earlier prokaryote-only or species-specific models.

## Intuition

The analogy with natural-language LLMs is direct: treat DNA as text, train a large autoregressive or masked model on it, and see what emerges. The bet is that biology's combinatorial complexity is amenable to the same "scale + diversity + self-supervision" recipe that made GPT-style models work for natural language.

Two things make DNA different from natural language and harder to get right:

1. **Length scales span many orders of magnitude.** A gene is ~1 kb, an operon ~10 kb, a bacterial genome ~1 Mb, a eukaryotic chromosome ~100 Mb, a mammalian genome ~3 Gb. Capturing dependencies across these scales requires very long context windows — orders of magnitude longer than typical NLP.
2. **Data is heterogeneous and biased.** Most sequenced DNA is from a small number of model organisms (humans, E. coli, yeast, mouse). Naïve training over-represents these and misses phylogenetic diversity. Training data curation is nontrivial — OpenGenome and OpenGenome2 are examples of deliberate curation efforts.

## Variants

- **Decoder-only autoregressive** — models like Evo 1, Evo 2, GenSLM, DeCodon. Trained to predict the next nucleotide. Naturally supports generation.
- **Encoder-only (masked)** — models like DNABERT, Nucleotide Transformer. Trained with masked-nucleotide objectives similar to BERT. Used mostly for prediction tasks via embeddings.
- **Prokaryote-only** — Evo 1, GenSLM, RNAErnie. Smaller, narrower, but historically the first to show meaningful performance.
- **Multi-species / all-domains** — [[evo-2]] (all domains of life including eukaryotes and humans) and Nucleotide Transformer (some multi-species variants).
- **Supervised fine-tuned variants** — e.g., lightweight classifiers trained on top of DNA LM embeddings for specific tasks (exon classification, variant effect prediction). These sit above the foundation model rather than being foundation models themselves.

## Tradeoffs

- **Context length is the central bottleneck.** To capture gene-gene interactions, operon structure, long-range enhancer/promoter relationships, or chromosome-scale topology, the model needs kilobase-to-megabase context. [[self-attention]] is quadratic, so pure transformers struggle here — which is why alternative architectures like [[striped-hyena-2]] (hyena operators + restricted attention) or state-space variants have traction.
- **Eukaryotic genomes are harder than prokaryotic.** Much more non-coding sequence, more regulatory complexity, alternative splicing, larger inter-gene distances. Pre-2025 DNA foundation models mostly punted on eukaryotes.
- **Evaluation is harder than for text LMs.** There's no "natural language understanding" equivalent. Papers typically report a mix of:
  - Zero-shot variant effect prediction against clinical databases (ClinVar, BRCA1 DMS).
  - Embedding-based classification (exon/intron, TF binding).
  - Generative sequence quality (Pfam hits, structural similarity, codon usage).
  - Needle-in-a-haystack for long context.
- **Biosafety concerns.** Excluding human-infecting viruses from training is now standard practice (both [[evo-2]] and Evo 1 do this). The Responsible AI × Biodesign commitments are a community norm — models should be red-teamed for pathogen generation before release.

## History & Lineage

**Early attempts (pre-2021):** k-mer embeddings, simple CNNs, small transformers trained on single-species genomes. Limited by data and compute.

**2021–2023:** DNABERT (Ji et al. 2021) — first major BERT-style DNA LM. Nucleotide Transformer (Dalla-Torre et al. 2024, developed earlier) — multispecies, multiple scales. GenSLM (Zvyagin et al. 2023) — genome-scale LM for prokaryotes.

**2024:** Evo 1 (Nguyen et al., Science) — first large DNA LM (7B params) with StripedHyena architecture, prokaryote/phage only but with 131k context. Demonstrated that genome-scale generation and zero-shot gene essentiality prediction were feasible.

**2026:** [[evo-2]] — the first DNA foundation model that is large, multi-species (including eukaryotes and humans), and long-context (1M tokens) simultaneously. The paper we're reading.

**Likely next directions:** multimodal integration with population genetics, functional genomics data (ATAC-seq, ChIP-seq), protein structure, and phenotypic data. The [[summary-evo-2|Evo 2 paper]] explicitly points at this.

## Sources

- [[summary-evo-2]]
