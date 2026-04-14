---
type: hot-cache
updated: 2026-04-13
---

### Current Focus
Just ingested [[summary-evo-2|Evo 2]] (Brixi et al., Nature 2026) — first cross-domain DNA foundation model with 1M-token context. The vault now spans two foundational papers: the [[transformer]] (NLP, pure attention) and [[evo-2]] (genomics, hybrid architecture). Wiki has been reorganized into a kind-based taxonomy: `concepts/{primitives,architectures,models,methods}`, `entities/{people,orgs,datasets}`, `sources/{year}/`. All existing pages moved via git mv; structure documented in `CLAUDE.md` § Wiki Taxonomy.

### Open Questions
Top picks from [[reading-queue]]:
- **Evo 1 (Nguyen et al. 2024, *Science*)** — the direct predecessor. Essential for understanding what Evo 2 changed (StripedHyena 1, prokaryote-only, 131k context).
- **Hyena Hierarchy (Poli et al. 2023, ICML)** — original [[hyena-operator]] paper. Architectural lineage we now reference but haven't ingested.
- **StripedHyena 2 systems paper (Ku et al. 2025, arXiv:2503.01868)** — engineering details for training a 40B hybrid model at 1M context.
- **Cunningham et al. 2023 (arXiv:2309.08600)** — foundational SAE-for-interpretability paper, the technique Evo 2 uses.
- **Bahdanau 2014 (NMT with attention)** and **BERT 2018** — still queued from the Transformer ingest.

### Recent Decisions
- 2026-04-13: Adopted kind-based wiki taxonomy (primitives/architectures/models/methods etc.). Structure must scale as papers accumulate; topic organization is left to the wikilink graph, not the filesystem.
- 2026-04-13: Multi-file sources get a dedicated subfolder under their type folder (e.g., `raw/papers/evo2/` for the Evo 2 paper + supplementary PDFs + xlsx tables). Documented in CLAUDE.md.
- 2026-04-13: System tools (poppler, etc.) go in `environment.yml` under conda-forge, not brew. Installed via `mamba env update` and run via `mamba run -n ai-wiki <command>`.
- 2026-04-13: Evo 2 figures not yet extracted despite CC BY-NC-ND grant — flagged as follow-up. The 70MB Nature PDF is large; figure extraction worth doing in a dedicated pass.

### Last Operations
- [2026-04-13] ingest | Genome modelling and design across all domains of life with Evo 2
- [2026-04-13] reorg | Wiki taxonomy subfolders
- [2026-04-13] ingest | Attention Is All You Need
- [2026-04-13] init | Vault bootstrapped

### Active Pages
- [[summary-evo-2]]
- [[evo-2]]
- [[striped-hyena-2]]
- [[hyena-operator]]
- [[dna-foundation-model]]
- [[sparse-autoencoder]]
- [[mechanistic-interpretability]]
- [[arc-institute]]
- [[brian-hie]]
- [[patrick-hsu]]
- [[michael-poli]]
- [[opengenome2]]
