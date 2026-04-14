---
type: source
title: "Genome modelling and design across all domains of life with Evo 2"
slug: summary-evo-2
source_file: raw/papers/evo2/s41586-026-10176-5_evo2.pdf
author: "Brixi, Durrant, Ku, Naghipourfar, Poli, Sun et al. (Arc Institute, Stanford, NVIDIA, Goodfire, Liquid AI)"
date_published: 2026-02-21
date_ingested: 2026-04-13
key_claims:
  - Evo 2 is a 7B/40B parameter biological foundation model trained on 9.3T nucleotides spanning all domains of life
  - StripedHyena 2 (convolutional multi-hybrid + rotary attention) gives up to 3x speedup over transformers at 40B/1M context
  - Two-phase training (8k context pretrain + multi-stage midtraining to 1M tokens) enables million-token DNA context windows
  - Zero-shot variant effect prediction is competitive with supervised models on ClinVar coding SNVs and SOTA on ClinVar noncoding non-SNVs and BRCA1 noncoding SNVs
  - Sparse autoencoder features on Evo 2 spontaneously align with biological concepts (prophages, exon boundaries, TF motifs, protein secondary structure) without supervision
  - Inference-time guidance (beam search over Enformer+Borzoi) enables experimentally-validated chromatin accessibility design including Morse-code peak patterns
related: [[evo-2]], [[striped-hyena-2]], [[hyena-operator]], [[dna-foundation-model]], [[sparse-autoencoder]], [[mechanistic-interpretability]], [[opengenome2]], [[arc-institute]], [[brian-hie]], [[patrick-hsu]], [[michael-poli]]
confidence: high
---

# Genome modelling and design across all domains of life with Evo 2

**Brixi, Durrant, Ku, Naghipourfar, Poli, Sun et al.** — *Nature*, published online 21 February 2026, accepted 22 January 2026, received 18 February 2025. DOI: [10.1038/s41586-026-10176-5](https://doi.org/10.1038/s41586-026-10176-5). Lead institutions: Arc Institute, Stanford University, with collaborators at NVIDIA, Goodfire, Liquid AI, UC Berkeley, and others.

The first DNA foundation model that is large, multi-species (including eukaryotes and humans), and long-context (1 million tokens at single-nucleotide resolution) simultaneously. Open-source release of model parameters, training code, inference code, and the OpenGenome2 dataset.

## Abstract

Although tools for genome sequencing, synthesis, and editing have transformed biological research, we still lack sufficient understanding of the immense complexity encoded by genomes to predict the effects of many genomic changes or to intelligently compose new biological systems. Here we introduce **[[evo-2|Evo 2]]**, a biological foundation model trained on 9 trillion DNA base pairs from a curated genomic atlas spanning all domains of life, with a 1-million-token context window at single-nucleotide resolution. Evo 2 accurately predicts the functional impacts of genetic variation — from noncoding pathogenic mutations to clinically significant BRCA1 variants — without task-specific fine-tuning. Mechanistic interpretability analyses reveal that Evo 2 learns representations associated with biological features including exon-intron boundaries, transcription factor binding sites, protein structural elements, and prophage genomic regions. The generative abilities of Evo 2 produce mitochondrial, prokaryotic, and eukaryotic sequences at genome scale, and Evo 2 generates experimentally-validated chromatin accessibility patterns when guided by predictive models and inference-time search. Evo 2 is fully open: parameters, training code, inference code, and the OpenGenome2 dataset.

## Key Contributions

1. **Evo 2 model family** — 7B parameters (2.4T training tokens) and 40B parameters (9.3T training tokens), with a 1-million-token context window at single-nucleotide resolution. See [[evo-2]].
2. **[[striped-hyena-2|StripedHyena 2]] architecture** — convolutional multi-hybrid combining three [[hyena-operator]] variants (short explicit, medium regularized, long implicit) with rotary attention. Up to 3× throughput speedup over highly optimized transformer baselines at 40B / 1M context.
3. **[[opengenome2|OpenGenome2]] training dataset** — 8.8+ trillion non-redundant nucleotides spanning bacteria, archaea, eukaryotes, and bacteriophage. First large-scale curated cross-domain genomic training corpus, with deliberate exclusion of eukaryote-infecting viruses for biosafety.
4. **Two-phase training strategy** — pretrain at 8,192-token context with data weighted toward functional genic windows, then multi-stage midtraining extends context up to 1M tokens. Mirrors best practice in natural-language LLMs.
5. **Zero-shot variant effect prediction across the central dogma** — without fine-tuning, Evo 2 is competitive with or exceeds specialized supervised models on ClinVar coding/noncoding pathogenicity, BRCA1 functional variants, splice-altering variants, and prokaryotic gene essentiality.
6. **[[mechanistic-interpretability|Mechanistic interpretability]] via [[sparse-autoencoder|Batch-TopK sparse autoencoders]]** — features spontaneously correspond to interpretable biological concepts (prophages, CRISPR spacers, exon-intron boundaries, TF binding motifs, protein secondary structure) without any supervision. First serious mech-interp analysis of a genome language model.
7. **Experimentally-validated genome design** — inference-time beam search guided by Enformer+Borzoi enables Evo 2 to design multi-kilobase sequences with controllable chromatin accessibility patterns, including Morse-code messages ("LO", "ARC", "EVO2") integrated into mouse and human cell lines and verified via ATAC-seq.

## Method

### Architecture

Evo 2 uses **[[striped-hyena-2|StripedHyena 2]]**, a convolutional multi-hybrid architecture interleaving three [[hyena-operator]] variants with rotary attention blocks (Fig. 1f of the source paper):

- **Short explicit (SE)** — small explicit convolution kernel for local mixing.
- **Medium regularized (MR)** — medium-range convolution with regularization.
- **Long implicit (LI)** — long-range implicit convolution computed via FFT, providing genome-scale reach.
- **Rotary attention** — RoPE-based attention sub-layers, kept for a subset of layers where attention's expressiveness is most valuable.

The hybrid layout gives each layer a different range of information mixing, allocating compute appropriately rather than forcing all layers through quadratic attention. Result: up to 3× throughput speedup vs optimized transformers at 40B params / 1M context (Fig. 1g), and equal-or-better loss scaling on DNA (Extended Data Fig. 1c). Companion systems paper: Ku et al. 2025 (arXiv:2503.01868).

### Training data: OpenGenome2

8.8+ trillion non-redundant nucleotides from:
- **Prokaryotes** (Genome Taxonomy Database / GTDB)
- **Archaea** (GTDB)
- **Eukaryotes** (curated NCBI genomes — Animalia, Plantae, Fungi, Protista)
- **Phage / viruses** (Integrated Microbial Genomes / Virus database / IMG/VR)
- Metagenomes and EPDnew promoter sequences for regulatory coverage

**Biosafety exclusion:** genomic sequences from viruses that infect eukaryotes (especially humans) are excluded. The exclusion is verified empirically — Evo 2 has high perplexity on these sequences (Extended Data Fig. 2a) and produces effectively random sequence recovery when prompted to generate viral proteins (Extended Data Fig. 2c). See [[opengenome2]].

### Training: two-phase

| Phase | Context | Data weighting | Purpose |
| :--- | :--- | :--- | :--- |
| **1. Pretraining** | 8,192 tokens | Functional genic windows | Learn local sequence motifs, codon usage, regulatory elements |
| **2. Midtraining** | Multi-stage extension up to 1,048,576 tokens | Long-sequence composition | Capture relationships across long genomic distances |

Mirrors best practice for natural-language LLMs (short-context pretrain → long-context extension). The paper shows validation perplexity improves with both model scale and longer context (Fig. 1h), and that needle-in-a-haystack recall succeeds at 1M tokens (Fig. 1i).

### Two model scales

| Model | Parameters | Training tokens | Final context |
| :--- | :--- | :--- | :--- |
| Evo 2 7B | 7 billion | 2.4 trillion | 1,048,576 |
| Evo 2 40B | 40 billion | 9.3 trillion | 1,048,576 |

A 1B short-context experimental model is also released but explicitly *not* recommended.

## Results

### Zero-shot evolutionary constraint (Fig. 2)

- **Single-nucleotide variant effects on likelihood** show three-base periodicity around start codons, stronger effects at codon position 1/2 vs 3 (wobble), and species-specific patterns for the Shine-Dalgarno (prokaryote) and Kozak (eukaryote) sequences upstream of CDSs.
- **Mutation type sensitivity:** non-synonymous, premature stop, and frameshift mutations cause much larger likelihood changes than synonymous mutations across 20 prokaryotic and 16 eukaryotic species.
- **Genetic code differentiation:** Evo 2 distinguishes the standard code, mycoplasma code, and ciliate code based on sequence context — when ciliate genomes are artificially recoded to the standard code, Evo 2 predicts the standard stop codons as deleterious in those sequences.
- **Deep mutational scanning correlation:** Evo 2 likelihoods correlate with experimental fitness across 9 prokaryotic protein, 6 eukaryotic protein, and 7 RNA datasets. Competitive with ProGen-family protein LMs but trails ESM-family on protein DMS.
- **Exon classification:** lightweight classifiers on Evo 2 7B embeddings achieve AUROC 0.91–0.99 on 8 held-out species, beating Nucleotide Transformer, Evo 1, conservation-based baselines, and the supervised ab initio AUGUSTUS tool. Beats SegmentNT outside its training set.
- **Gene essentiality:** Evo 2 predicts prokaryotic gene essentiality competitively with Evo 1; modest performance on human gene essentiality (AUROC 0.66 — within the range of PhyloP conservation, an honest limitation).

### Human variant effect prediction (Fig. 3)

The headline application. Evo 2 scores variants by computing $\Delta$likelihood between reference and mutant sequence, then predicting pathogenicity from the magnitude.

| Task | Best Evo 2 result | Comparison |
| :--- | :--- | :--- |
| ClinVar coding SNVs | Competitive with AlphaMissense / GPN-MSA / ESM-1b | Behind ESM-1b on AUROC |
| ClinVar coding non-SNVs | **SOTA** | Many comparison models can't even score non-SNVs |
| ClinVar noncoding SNVs | Best among unsupervised models | Behind supervised SpliceAI / CADD only |
| ClinVar noncoding non-SNVs | **SOTA across all models** | |
| Splice variants (SpliceVarDB) | Best among unsupervised | Slightly behind SpliceAI on intronic |
| BRCA1 coding+noncoding combined | Strong; **SOTA on BRCA1 noncoding SNVs** | |
| BRCA1 with supervised classifier on Evo 2 embeddings | AUROC 0.95, AUPRC 0.88 | Beats zero-shot Evo 2 |

The non-SNV result is particularly significant: leading variant effect predictors (AlphaMissense, GPN-MSA) operate only on substitutions. Evo 2's unified scoring works for insertions, deletions, and duplications too.

### Mechanistic interpretability (Fig. 4)

A **Batch-TopK [[sparse-autoencoder]]** trained on Evo 2 layer-26 representations (1B tokens of activations, evenly split across complete eukaryotic and prokaryotic genomes) yields features that align with known biology *without supervision*:

- **Prophage feature (f/19746)** — activates on annotated prophages in *E. coli K12*, including the cryptic prophage CPZ-55. Also activates on **CRISPR spacer sequences** within CRISPR arrays — the model associates spacers with their phage origin rather than memorizing phage genomes. (One of the most striking results in the paper.)
- **Genomic element features** — distinct features for ORFs, intergenic regions, tRNAs, and rRNAs.
- **Protein structural features** — features for α-helices and β-sheets, validated via AlphaFold 3 structure predictions of EF-Tu/tRNA and RpoB/RpoC complexes.
- **Mutation-sensitive features** — a feature (f/24278) preferentially activates on frameshift and premature stop mutations over less deleterious mutation types in human coding sequences.
- **Transcription factor binding motifs** — features activate on motifs in human gene promoters that match HOCOMOCO v.12 CORE database entries. **Evo 2 SAE features recall 70% of HOCOMOCO motifs vs HOMER's 35%** on the same dataset — a striking benchmark against a specialized motif-discovery tool.
- **Exon boundaries** — features for coding regions, introns, first exon base after intron (f/1050), last exon base before intron (f/25666). The boundary features integrate signals across multi-nucleotide splice sites.
- **Cross-species transfer** — features identified on model organisms transfer to a sequenced woolly mammoth genome.

### Genome-scale generation (Fig. 5)

Evo 2 generates DNA at three length scales:

- **Mitochondrial genomes** (16 kb): generates 250+ unique sequences from human mitochondrial DNA prompts. Generated sequences have correct CDS, tRNA, and rRNA counts, AlphaFold 3-predicted multimeric complexes match human mitochondrial proteins, codon usage matches the human mitochondrial genome.
- ***M. genitalium* prokaryotic genomes** (580 kb): from a 10.5 kb seed, generates ten 580-kb sequences. **70% of generated genes have significant Pfam hits** (vs 18% for Evo 1 131k). Generated proteins have natural-looking length and secondary-structure distributions.
- ***S. cerevisiae* eukaryotic chromosome** (330 kb): generates 20 yeast chromosome sequences from a 10.5 kb seed. Includes tRNAs, promoters, and intronic gene structure. Tetranucleotide usage deviation correlates with native S. cerevisiae, and the correlation is stronger for Evo 2 40B than 7B.

The authors are explicit that *in silico* metrics don't guarantee functional, replication-competent genomes — that's a much harder experimental bar for follow-up work.

### Chromatin accessibility design (Fig. 6) — the experimental capstone

Inference-time guidance: **beam search** over generated 128-bp chunks, scored by an ensemble of **Enformer + Borzoi** chromatin accessibility predictors. Increasing beam width (more inference compute) gives log-linear improvement in design quality, paralleling natural-language inference-scaling results.

**Designed Morse code patterns** ("LO", "ARC", "EVO2") with narrow peaks = dots, wide peaks = dashes, inaccessible regions = spaces. Synthesized, integrated into mouse embryonic stem cells via site-specific integration, measured by ATAC-seq. Experimental AUROC 0.92–0.95 — **the predicted patterns match the measured chromatin accessibility**.

Extended to **HEK293T and K562 human cell lines**: 33 of 36 single-cell-type designs achieved AUROC > 0.8. Differential designs (different patterns in two cell types) are harder — 4 of 24 achieved >2× differential, 1 of 24 achieved >3×.

This is the paper's strongest experimental result: a generative DNA model whose designs work in actual mammalian cells.

## Discussion

### Authors' own framing of limits

- **Generative evaluations are *in silico*.** "Our evaluation metrics do not guarantee functional or replication-competent genomes, and our genome-scale generations lack important elements, such as some essential genes. Experimentally testing genome-scale designs will also require large-scale, iterative effort."
- **Inference-time guidance is computationally expensive.** Beam search over Enformer+Borzoi for design tasks adds nontrivial compute. Supervised fine-tuning or RL with biological feedback is suggested as a more efficient direction.
- **Human variant effect prediction is improving but not solved.** Evo 2 is a major step over previous DNA LMs but still trails supervised models on coding SNV pathogenicity in some settings.
- **DMS performance saturates with scale on proteins.** Consistent with broader observations about protein language models — bigger isn't always better past a certain point.

### Biosafety and red-teaming

The authors collaborated with multidisciplinary experts on biosafety. Their measures:
- Excluding eukaryote-infecting viruses from training data.
- Verifying that exclusions produce intended weakness (high perplexity, random viral protein generation).
- Red-teaming with adversarial prompts attempting to elicit pathogenic human viral proteins.
- Population bias evaluations to ensure the model isn't ancestrally biased.

The paper argues this represents "one of the most comprehensive evaluative efforts thus far" for biological foundation model risk assessment. Aligned with the Responsible AI × Biodesign commitments.

### Future directions named in the paper

- Combining Evo 2 with population-scale variation, sequence-to-function experiments, and other modalities.
- Using mech interp for genome mining and discovery of more complex element combinations.
- Supervised fine-tuning and RL with biological feedback to improve generation quality and efficiency.
- Multimodal models that simulate complex phenotypes in health and disease.

## Suggested Next Reads

Five candidate follow-up ingests, most drawn from the Evo 2 bibliography. All five are mirrored in [[reading-queue]].

1. **Nguyen et al. 2024 — Sequence modeling and design from molecular to genome scale with Evo** (*Science* 386, eado9336). The direct predecessor — Evo 1, prokaryote-only, StripedHyena 1 architecture. Essential context for understanding what Evo 2 changed.
2. **Ku et al. 2025 — Systems and algorithms for convolutional multi-hybrid language models at scale** ([arXiv:2503.01868](https://arxiv.org/abs/2503.01868)). Companion systems paper for [[striped-hyena-2|StripedHyena 2]]. Engineering details of how to train a 40B hybrid model at 1M context.
3. **Poli et al. 2023 — Hyena Hierarchy: Towards Larger Convolutional Language Models** (ICML 2023). Original [[hyena-operator]] paper. Essential for understanding the architectural lineage.
4. **Cunningham, Ewart, Smith, Huben, Sharkey 2023 — Sparse Autoencoders Find Highly Interpretable Features in Language Models** ([arXiv:2309.08600](https://arxiv.org/abs/2309.08600)). The foundational SAE-for-interpretability paper. The technique Evo 2 uses for [[mechanistic-interpretability|mech interp]] of biology.
5. **Dalla-Torre et al. 2024 — Nucleotide Transformer: building and evaluating robust foundation models for human genomics** (*Nature Methods* 22, 287–297). Prior major DNA foundation model that Evo 2 benchmarks against extensively.

## Provenance

- **Source files:** `raw/papers/evo2/` (multi-file source subfolder)
  - `s41586-026-10176-5_evo2.pdf` — main paper (33 pages, 70 MB)
  - `41586_2026_10176_MOESM1_ESM.pdf` — Supplementary Information 1
  - `41586_2026_10176_MOESM4_ESM.pdf` — Supplementary Information 4
  - `41586_2026_10176_MOESM3_ESM.xlsx` — Supplementary Data Table 3
  - `41586_2026_10176_MOESM5_ESM.xlsx` — Supplementary Data Table 5
- **Source format:** Nature publisher PDF. Read via `pdftotext` extraction (poppler from the project's conda env). Supplementary PDFs read but not yet incorporated in detail — flagged for future deeper passes if specific claims need verification.
- **Figures:** not yet extracted to `raw/assets/`. The paper's Open Access notice grants Creative Commons Attribution-NonCommercial-NoDerivatives 4.0: *"non-commercial use, sharing, distribution and reproduction in any medium or format, as long as you give appropriate credit to the original author(s) and the source, provide a link to the Creative Commons licence, and indicate if you modified the licensed material."* Reproduction is permitted (with attribution), so figures *can* be extracted and committed in a follow-up pass under a narrow `!raw/assets/evo-2-*` gitignore exception.
- **License:** CC BY-NC-ND 4.0. Figures and tables can be reproduced as-is with attribution; modified derivatives are not permitted; non-commercial use only. Commercial use of Evo 2 outputs themselves is governed separately by the model release terms at arcinstitute.org.

## Related

- [[evo-2]]
- [[striped-hyena-2]]
- [[hyena-operator]]
- [[dna-foundation-model]]
- [[sparse-autoencoder]]
- [[mechanistic-interpretability]]
- [[opengenome2]]
- [[arc-institute]]
- [[brian-hie]]
- [[patrick-hsu]]
- [[michael-poli]]
