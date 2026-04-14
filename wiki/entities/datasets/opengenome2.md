---
type: entity
entity_type: product
title: "OpenGenome2"
aliases: [opengenome2, opengenome 2]
sources:
  - [[summary-evo-2]]
related:
  - [[evo-2]]
  - [[arc-institute]]
created: 2026-04-13
updated: 2026-04-13
---

# OpenGenome2

## What / Who

**OpenGenome2** is the curated genomic training dataset assembled for [[evo-2]] by the team at [[arc-institute|Arc Institute]]. It contains **8.8+ trillion nucleotides** of non-redundant DNA sequence spanning all four domains of life: bacteria, archaea, eukaryotes, and bacteriophage/viruses. Released openly alongside the Evo 2 model parameters and code.

## Significance

OpenGenome2 is the practical enabler of cross-domain DNA foundation modeling. Prior DNA language models were either:
- Restricted to prokaryotes (Evo 1 was bacteria + phage only),
- Biased toward a few model organisms (humans, E. coli, yeast, mouse), or
- Small enough that data quality issues were masked by data quantity issues.

OpenGenome2 is **deliberately curated for non-redundancy and phylogenetic breadth** — a UMAP of its sequences (Fig. 1b in [[summary-evo-2]]) covers the major branches of life with reasonable evenness rather than being dominated by a few well-sequenced clades. This curation is what allows Evo 2 to learn genuinely cross-domain representations (e.g., features that generalize from human to woolly mammoth genomes, or from bacteria to eukaryotic exons).

A second key property is **biosafety-driven exclusion**: genomic sequences from viruses that infect eukaryotes (and especially humans) are deliberately excluded from training. The Evo 2 paper verifies this exclusion is effective — the model has high perplexity on excluded virus sequences and effectively random performance when prompted to generate human viral proteins. This is now a community standard for DNA foundation models.

## Timeline / Notable Work

- **2026** — Released alongside [[evo-2]]. The first openly-released cross-domain genomic training dataset at the trillion-nucleotide scale.
- Composition (Fig. 1d of the source paper):
  - **Prokaryotes** — via Genome Taxonomy Database (GTDB).
  - **Archaea** — via GTDB.
  - **Eukaryotes** — Animalia, Plantae, Fungi, Protista (curated subset of NCBI genomes).
  - **Phage / viruses** — via Integrated Microbial Genomes / Virus database (IMG/VR), excluding eukaryote-infecting viruses.
  - Metagenomic sequences and EPDnew promoter database for additional regulatory coverage.

## Relationships

- [[evo-2]] — the model trained on OpenGenome2.
- [[arc-institute]] — curated and released the dataset.

## Sources

- [[summary-evo-2]]
