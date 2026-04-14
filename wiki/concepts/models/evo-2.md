---
type: concept
title: "Evo 2"
aliases: [evo 2, evo2]
sources:
  - [[summary-evo-2]]
related:
  - [[dna-foundation-model]]
  - [[striped-hyena-2]]
  - [[hyena-operator]]
  - [[sparse-autoencoder]]
  - [[mechanistic-interpretability]]
  - [[opengenome2]]
  - [[arc-institute]]
  - [[brian-hie]]
  - [[patrick-hsu]]
  - [[michael-poli]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Evo 2

## Definition

**Evo 2** is a biological foundation model — a large language model of DNA trained on 9.3 trillion nucleotides of curated genomic sequence spanning all domains of life (bacteria, archaea, eukarya, bacteriophage). It is released in two sizes (7B and 40B parameters) with a 1-million-token context window at single-nucleotide resolution. Introduced by Brixi et al. (Arc Institute, Stanford, NVIDIA, Goodfire, Liquid AI) in [[summary-evo-2|Genome modelling and design across all domains of life with Evo 2]] (Nature 2026).

## Intuition

Prior DNA language models were either small, narrow in organismal coverage (e.g. prokaryote-only like Evo 1), or short in context (a few kilobases). Evo 2 is the first DNA model that is **large, cross-domain, and long-context simultaneously** — the combination of scale, multi-species training data, and million-token context window is what enables it to capture biological patterns that span a single gene (kilobases), operons and regulatory regions (tens of kilobases), whole bacterial genomes (megabases), and chromosome-scale eukaryotic structure.

The core bet is that the same pattern that made natural-language LLMs work — train a generic sequence model at massive scale on diverse text — transfers to DNA when the sequence model can actually handle genomic length scales and the training corpus spans the full diversity of life.

## Formulation

**Two scales:**

| Model | Parameters | Training tokens | Context length |
| :--- | :--- | :--- | :--- |
| Evo 2 7B | 7 billion | 2.4 trillion | 1M (after midtraining) |
| Evo 2 40B | 40 billion | 9.3 trillion | 1M (after midtraining) |

**Architecture:** [[striped-hyena-2]] — a convolutional multi-hybrid combining three [[hyena-operator]] variants (short explicit, medium regularized, long implicit) with rotary attention. Up to 3× speedup over optimized transformer baselines at 40B / 1M context.

**Training data:** [[opengenome2]] — 8.8+ trillion nucleotides from bacteria (via GTDB), archaea, eukaryotes, phage/viruses (via IMG/VR and RefSeq), and metagenomes. **Viruses that infect eukaryotes are explicitly excluded for biosafety** — the authors verified this exclusion produces intended weakness on eukaryotic viral sequences (poor language modeling, essentially random mutational effect prediction).

**Two-phase training:**
1. **Pretraining** at 8,192-token context on data weighted toward functional genic windows. Mirrors the short-context pretraining phase of natural-language LLMs.
2. **Midtraining** extends context in multiple stages up to 1M tokens, with data weighted toward long-sequence composition. This matches best practice from LLMs (short-context pretrain → long-context extension) and is the practical enabler of the 1M context window actually working.

**Verification:** a DNA needle-in-a-haystack evaluation demonstrates effective recall of a 100-bp "needle" hidden within 1 million bp of random DNA.

## Variants

- **Evo 2 7B** — lightweight version, competitive on most tasks but below 40B on the hardest variant-effect predictions and genome-scale generation. Preferred when inference cost matters.
- **Evo 2 40B** — best overall, especially for eukaryotic tasks. 1M-context version is the flagship.
- **Evo 2 1B** — experimental short-context model released alongside the larger ones, but the paper explicitly recommends avoiding it due to overall weaker performance.
- **Evo 1** (2024, Nguyen et al.) — the direct predecessor. Trained on prokaryotic and phage sequences only, smaller scale, shorter context. Based on StripedHyena 1.

## Tradeoffs

- **Protein DMS performance saturates/declines with scale.** Evo 2 is competitive with ProGen-family protein LMs on protein deep mutational scanning but *underperforms* specialized protein LMs like ESM-2. The paper notes DMS performance "begins to saturate and can decrease at the largest model scales" — consistent with observations for protein language models. This is an honest, empirically-observed limitation.
- **Human gene essentiality prediction is modest.** AUROC 0.66 on human gene essentiality — better than other genomic LMs (0.50–0.59) but within the range of simple PhyloP conservation scores (0.65–0.71). Zero-shot human variant effect prediction is a hard task where Evo 2 doesn't dominate.
- **Distal regulatory variants are harder than coding.** Evo 2 trails supervised sequence-to-function models (ChromBPNet) on chromatin accessibility QTLs — sequence-only foundation models capture some regulatory information but task-specific supervised training still wins here.
- **Generative evaluations are *in silico*.** The genome-scale generations (mitochondrial, M. genitalium-sized, yeast chromosome) pass annotation metrics but have not been shown to produce functional, replication-competent organisms. That's a much harder experimental bar the authors explicitly acknowledge.
- **Compute cost.** Training a 40B model on 9.3T tokens is expensive. Evo 2 was trained with substantial NVIDIA collaboration — not reproducible by most labs without similar resource access.

## History & Lineage

**Predecessor:** Evo 1 (Nguyen et al., Science 2024) — StripedHyena 1 architecture, 7B params, prokaryote/phage only, 131k context. Evo 2 extends Evo 1 in three ways: (1) architectural upgrade to StripedHyena 2, (2) expansion to eukaryotes and all domains of life via OpenGenome2, (3) context extension from 131k to 1M tokens via two-phase training.

**Architectural lineage:** Hyena Hierarchy (Poli et al. 2023) → StripedHyena 1 (Poli et al. 2024) → StripedHyena 2 (Ku et al. 2025, companion systems paper arXiv:2503.01868) → Evo 2 (this paper). [[michael-poli|Michael Poli]] is the common thread.

**Release:** fully open source — model parameters for both 7B and 40B, distributed training code, multi-GPU inference code, the complete OpenGenome2 dataset, and web tools for sequence design and SAE feature exploration. The paper notes this is "one of the largest-scale fully open models thus far (including training and inference code, data and parameters), even across other modalities."

**Significance:** represents the point at which DNA foundation models transitioned from research curiosities to clinically-relevant tools. Zero-shot ClinVar pathogenicity prediction competitive with specialized supervised models, BRCA1 noncoding SNV prediction at SOTA, and experimentally-validated chromatin accessibility design in mammalian cells are concrete demonstrations of this transition.

## Figures

The main paper's Figure 1 gives an overview: (a) applications across the central dogma, (b) UMAP of training data phylogenetic coverage, (c) two-phase training, (d) dataset composition, (e) token counts, (f) StripedHyena 2 block layout, (g) throughput vs transformers and StripedHyena 1, (h) validation perplexity by scale and context, (i) needle-in-a-haystack results at 1M context.

*(Figures not yet extracted from `raw/papers/evo2/s41586-026-10176-5_evo2.pdf`. The Nature CC BY-NC-ND license permits reproduction with attribution — figures can be added to `raw/assets/` in a follow-up pass.)*

## Sources

- [[summary-evo-2]]
