---
type: concept
title: "Mechanistic Interpretability"
aliases: [mech interp, mechanistic interp]
sources:
  - [[summary-evo-2]]
related:
  - [[sparse-autoencoder]]
  - [[evo-2]]
created: 2026-04-13
updated: 2026-04-13
confidence: high
---

# Mechanistic Interpretability

## Definition

**Mechanistic interpretability** (often *mech interp*) is a research program in machine learning that aims to reverse-engineer trained neural networks into human-understandable algorithms. The goal is not just to *predict* what a model will do, but to identify the specific circuits, features, and computations inside the model that *cause* its behavior — analogous to the difference between using a program and decompiling it.

## Intuition

Most ML interpretability prior to mech interp focused on *post-hoc* explanations: saliency maps, LIME, SHAP, attention visualization. These say "input feature X mattered for output Y" without explaining *how* the model used X. Mech interp goes deeper: it tries to identify the actual structures inside the model — features, circuits, attention heads with specific roles — that implement the input-to-output transformation.

The premise is that large neural networks, despite their opaque appearance, **learn structured internal representations and algorithms that can in principle be decoded**. Concretely, this means looking for:

- **Features:** directions in activation space that correspond to coherent concepts. A feature for "phage DNA" or "exon boundary" or "TF binding site," not just neuron 4123.
- **Circuits:** subnetworks that implement specific algorithms. An attention head that does indirect-object identification, or a layer that performs syntactic agreement.
- **Universal motifs:** structures that appear across different models, suggesting they're a consequence of the data and task rather than the specific architecture.

When this works, the result is genuinely useful: you can predict and intervene on model behavior in ways that black-box analysis can't. When it fails (yet), it's because the features are polysemantic, the circuits are too distributed, or the interpretability tools are too crude.

## Formulation

Mech interp is a research program, not a single algorithm. Its toolkit includes:

- **Probing** — train lightweight classifiers on internal activations to detect whether a concept is *represented* (not necessarily *used*).
- **Activation patching / causal interventions** — replace activations from one input with activations from another and observe the effect on output. Tests whether a representation is causally relevant.
- **[[sparse-autoencoder|Sparse autoencoders]]** — decompose polysemantic activations into approximately monosemantic features. The dominant tool for feature extraction in 2024–2026.
- **Logit lens / tuned lens** — project intermediate activations through the unembedding to see "what the model would output if it stopped here."
- **Circuit analysis** — identify subgraphs of the model that implement specific behaviors via combinations of patching, ablation, and visualization.
- **Steering** — add or subtract feature directions from activations at inference time to manipulate model behavior. Validates that an identified feature is causally meaningful.

## Variants

- **Probing-based interp** — older tradition, uses linear probes to detect represented information. Limited by the probe vs. use distinction (a probe can find information the model doesn't use).
- **Circuit-level interp** — associated with Anthropic's circuits thread and Conmy et al.'s automatic circuit discovery work. Identifies named subcircuits like "induction heads."
- **Feature-level interp** — the current dominant strand, centered on SAEs. Decompose activations into feature dictionaries and study individual features. Templeton et al. 2024 ("Scaling monosemanticity") on Claude 3 Sonnet is the production-scale example.
- **Cross-modal interp** — applying these methods outside language models. [[evo-2]] is a leading example for DNA; protein language models (ESM family) and vision transformers have parallel efforts.

## Tradeoffs

- **Correlation vs causation is the hardest problem.** Finding a feature that *fires when* the input mentions phages doesn't prove the model *uses* that feature to make phage-related predictions. Causal interventions (patching, steering) are needed but expensive.
- **Polysemantic vs monosemantic.** Real model neurons are usually polysemantic — they encode multiple unrelated concepts. SAEs are designed to undo this, but the success of feature decomposition depends on the SAE training, the layer, and the model.
- **Scale.** Modern LLMs have billions of parameters and millions of features. Manual circuit analysis doesn't scale; automatic methods are still maturing.
- **Validation is hard.** "I trained an SAE and the features look interpretable" is the start of an analysis, not the end. Papers typically validate via correlation with known labels, motif comparison, structural overlap, or steering experiments — but these are all imperfect.
- **Interpretability is task-specific.** What counts as "interpretable" depends on the domain. For natural language, semantic concepts (sentiment, syntax). For DNA, biological annotations (exons, motifs, mobile elements). For proteins, structural features.

## History & Lineage

**Pre-2020:** scattered work on probing and visualization in CV and NLP. Lots of saliency-map heuristics, mostly unsatisfying.

**2020–2022:** Anthropic's Circuits thread (Olah et al.) on Inception V1 and language models — induction heads, named circuits, the "transformer circuits" framing. Establishes the modern mech interp vocabulary.

**2023:**
- Cunningham et al. ("Sparse autoencoders find highly interpretable features", arXiv:2309.08600) — first SAE-based feature extraction at meaningful scale.
- Bricken et al. ("Towards monosemanticity", Transformer Circuits Thread) — SAEs on a one-layer transformer, validates the monosemanticity hypothesis.

**2024:**
- Templeton et al. ("Scaling monosemanticity") — SAEs on Claude 3 Sonnet, millions of features, abstract concept extraction.
- Multiple papers on improved SAE variants (TopK, Batch-TopK, JumpReLU).
- Automatic circuit discovery methods.

**2026:** [[evo-2]] applies Batch-TopK SAEs to a 40B-parameter genome model and finds biologically meaningful features without supervision. This is one of the first cross-modal mech interp results outside text — evidence that the toolkit transfers beyond language models.

**Where it's going:** integration with steering and editing (controlling model behavior via feature manipulation), automatic interpretability (using LLMs to label SAE features), and feature universality (do the same features show up across different models trained on the same domain?).

## Sources

- [[summary-evo-2]]
