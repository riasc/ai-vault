---
type: hot-cache
updated: 2026-04-13
---

### Current Focus
Ingested "Attention Is All You Need" (Vaswani et al. 2017) — the Transformer foundation paper. Seven concept pages now cover the attention cluster ([[transformer]], [[self-attention]], [[scaled-dot-product-attention]], [[multi-head-attention]], [[positional-encoding]], [[encoder-decoder-architecture]], [[attention-mechanism]]).

### Open Questions
- Which direction to expand next: encoder-only descendants (BERT), decoder-only (GPT/Llama), position-encoding evolution (RoPE/ALiBi), or efficient-attention variants (Flash Attention, Mamba)?
- Scaling laws (Kaplan 2020, Chinchilla 2022) are another obvious next ingest.
- Several author entity pages are stubs — they'll flesh out as more sources arrive that reference these people.

### Recent Decisions
- 2026-04-13: Adopted flat `raw/` structure (no year/topic subfolders) — the wiki is the taxonomy, not the filesystem.
- 2026-04-13: Gitignored `raw/{papers,articles,transcripts,assets}` for copyright reasons; `.gitkeep` files preserve folder structure.
- 2026-04-13: For papers with inline TikZ/LaTeX figures, rasterize from the compiled arXiv PDF with pdftoppm rather than compiling the source tarball.
- 2026-04-13: First ingest touched 18 files (14 created + 4 updated) — above the typical 5–15 range, but justified because this is the foundational paper seeding an entire concept cluster from an empty wiki.

### Last Operations
- [2026-04-13] ingest | Attention Is All You Need
- [2026-04-13] init | Vault bootstrapped

### Active Pages
- [[summary-attention-is-all-you-need]]
- [[transformer]]
- [[self-attention]]
- [[multi-head-attention]]
- [[scaled-dot-product-attention]]
- [[positional-encoding]]
- [[encoder-decoder-architecture]]
- [[attention-mechanism]]
