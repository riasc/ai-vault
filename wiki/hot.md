---
type: hot-cache
updated: 2026-04-13
---

### Current Focus
Ingested "Attention Is All You Need" (Vaswani et al. 2017) — the Transformer foundation paper. Seven concept pages now cover the attention cluster ([[transformer]], [[self-attention]], [[scaled-dot-product-attention]], [[multi-head-attention]], [[positional-encoding]], [[encoder-decoder-architecture]], [[attention-mechanism]]). All 14 pages from this ingest have been retrofitted to match the standardized body templates in `CLAUDE.md`.

### Open Questions
Top picks from [[reading-queue]]:
- [[summary-attention-is-all-you-need|Attention Is All You Need]] → **Bahdanau 2014 (NMT with attention, arXiv:1409.0473)** — the original attention mechanism, the direct foil to the Transformer's contribution.
- **Sutskever 2014 (seq2seq, arXiv:1409.3215)** — foundational encoder-decoder paper that defined the vocabulary the Transformer inherits.
- **Luong 2015 (effective attention, arXiv:1508.04025)** — direct precursor to scaled dot-product attention.
- **BERT 2018 (Devlin et al., arXiv:1810.04805)** — first major encoder-only Transformer descendant; the obvious forward step.

See `wiki/reading-queue.md` for the full queue (Ba 2016 LayerNorm and Shazeer 2017 MoE also queued).

### Recent Decisions
- 2026-04-13: Adopted flat `raw/` structure — the wiki is the taxonomy, not the filesystem.
- 2026-04-13: Gitignored `raw/{papers,articles,transcripts,assets}` for copyright reasons; narrow per-paper exception for figures when the source grants reproduction rights (e.g. `!raw/assets/1706.03762-*` covers Google's grant on the Vaswani paper).
- 2026-04-13: Standardized concept / entity / source page body templates in `CLAUDE.md`. All existing pages retrofitted.
- 2026-04-13: Added `wiki/reading-queue.md` — every ingest now appends 3–6 candidate next reads drawn from the source's bibliography plus forward-looking gaps.
- 2026-04-13: Publishing to GitHub Pages deferred until ~5–10 papers; Quartz is the intended tool when the time comes.

### Last Operations
- [2026-04-13] ingest | Attention Is All You Need
- [2026-04-13] init | Vault bootstrapped

### Active Pages
- [[summary-attention-is-all-you-need]]
- [[reading-queue]]
- [[transformer]]
- [[self-attention]]
- [[multi-head-attention]]
- [[scaled-dot-product-attention]]
- [[positional-encoding]]
- [[encoder-decoder-architecture]]
- [[attention-mechanism]]
