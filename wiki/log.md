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
