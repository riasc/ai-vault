# Activity Log

Append-only chronological record of all wiki operations.

Entry format:
```
## [YYYY-MM-DD] {ingest|query|lint} | {title/description}
Source: ...
Pages created: ...
Pages updated: ...
Contradictions flagged: ...
```

---

## [2026-04-13] init | Vault bootstrapped
Vault initialized with Karpathy LLM Wiki Stack pattern.
Domain: AI/ML research, recent technologies, learning material.
Pages created: wiki/index.md, wiki/log.md, wiki/hot.md, wiki/overview.md, CLAUDE.md
Status: empty wiki, awaiting first ingest.

## [2026-04-13] ingest | Attention Is All You Need
Source: raw/papers/1706.03762v7-attention-is-all-you-need.tar.gz (arXiv v7 LaTeX tarball)
Figures: raw/assets/1706.03762-fig1-transformer-architecture.pdf, raw/assets/1706.03762-fig2-attention-mechanisms.pdf, raw/assets/1706.03762-anaphora-resolution-{1,2}.pdf, raw/assets/1706.03762-attention-heads-{1,2}.pdf, raw/assets/1706.03762-long-distance-making-{1,2}.pdf
Pages created (14): wiki/sources/summary-attention-is-all-you-need.md, wiki/concepts/transformer.md, wiki/concepts/attention-mechanism.md, wiki/concepts/self-attention.md, wiki/concepts/scaled-dot-product-attention.md, wiki/concepts/multi-head-attention.md, wiki/concepts/positional-encoding.md, wiki/concepts/encoder-decoder-architecture.md, wiki/entities/ashish-vaswani.md, wiki/entities/noam-shazeer.md, wiki/entities/aidan-gomez.md, wiki/entities/illia-polosukhin.md, wiki/entities/google-brain.md, wiki/entities/wmt-2014.md
Pages updated: wiki/index.md, wiki/overview.md, wiki/hot.md
Contradictions flagged: none (first ingest, no prior claims to contradict)
Notes: Read all .tex source files directly from extracted tarball (/tmp/attention-src/). Viewed Figure 1 and Figure 2 PDFs during ingest to ground architecture descriptions. Attention visualization PDFs referenced by path in self-attention and multi-head-attention concept pages; captions alone were sufficient for the summaries without individually rendering each file.

## [2026-04-13] reorg | Wiki taxonomy subfolders
Reorganized wiki/ into a kind-based taxonomy: concepts/{primitives,architectures,models,methods}, entities/{people,orgs,datasets}, sources/{year}. Moved all 14 existing pages from the Vaswani ingest into the new structure via git mv (history preserved). Updated CLAUDE.md with the taxonomy section, category definitions, edge-case rules, and the multi-file source subfolder convention for raw/papers/. Wikilinks unchanged — Obsidian resolves by filename, not path.

## [2026-04-13] ingest | Genome modelling and design across all domains of life with Evo 2
Source: raw/papers/evo2/ (multi-file source subfolder)
  - s41586-026-10176-5_evo2.pdf (33 pages, 70 MB main paper)
  - 41586_2026_10176_MOESM{1,4}_ESM.pdf (supplementary PDFs)
  - 41586_2026_10176_MOESM{3,5}_ESM.xlsx (supplementary data tables)
Pages created (12): wiki/sources/2026/summary-evo-2.md, wiki/concepts/models/evo-2.md, wiki/concepts/models/dna-foundation-model.md, wiki/concepts/architectures/striped-hyena-2.md, wiki/concepts/primitives/hyena-operator.md, wiki/concepts/methods/sparse-autoencoder.md, wiki/concepts/methods/mechanistic-interpretability.md, wiki/entities/orgs/arc-institute.md, wiki/entities/people/brian-hie.md, wiki/entities/people/patrick-hsu.md, wiki/entities/people/michael-poli.md, wiki/entities/datasets/opengenome2.md
Pages updated: wiki/concepts/architectures/transformer.md (added "Alternatives and challengers" subsection linking to StripedHyena 2), wiki/concepts/primitives/self-attention.md (added "See also" section noting hyena/StripedHyena 2 alternatives), wiki/index.md, wiki/overview.md, wiki/hot.md, wiki/reading-queue.md
Contradictions flagged: none (Evo 2 sits in a different domain from the Transformer paper — no overlap to contradict)
Notes: Read main paper text via pdftotext (poppler installed via conda env, see environment.yml). Did not extract figures this round despite CC BY-NC-ND license permitting reproduction — flagged for follow-up. Supplementary PDFs read but not deeply incorporated. Multi-file source uses raw/papers/evo2/ subfolder, the new convention now documented in CLAUDE.md.
