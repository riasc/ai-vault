# AI Wiki

A personal, LLM-maintained knowledge base for AI/ML research, recent technologies, and learning material. Built as an Obsidian vault using the [Karpathy LLM Wiki Stack](https://github.com/ScrapingArt/Karpathy-LLM-Wiki-Stack) pattern, based on Andrej Karpathy's [original gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

## What this is

Instead of a flat note collection or a RAG-over-PDFs system, this vault is a **compounding wiki**: a human curates raw sources, an LLM agent (Claude Code) compiles them into a structured, interlinked knowledge base, and the wiki is kept current as new sources arrive.

> "The wiki is a persistent, compounding artifact. The knowledge is compiled once and then kept current, not re-derived on every query." — Karpathy

## Architecture

Three layers with strict ownership:

| Layer | Folder | Owner | Rule |
| :--- | :--- | :--- | :--- |
| **1. Raw sources** | `raw/` | Human | LLM never modifies |
| **2. Wiki** | `wiki/` | LLM | Human reads only |
| **3. Schema** | `CLAUDE.md` | Co-evolved | LLM reads at every session start |

```
AI/
├── CLAUDE.md                ← master schema (workflows + frontmatter rules)
├── README.md                ← you are here
├── environment.yml          ← conda env for CLI tools
├── scripts/
│   └── setup-cli-tools.sh   ← installs defuddle + qmd via npm
│
├── raw/                     ← immutable source documents (drop files here)
│   ├── articles/            ← clipped web articles
│   ├── papers/              ← PDFs, academic papers
│   ├── repos/               ← README.md / architecture notes from code repos
│   ├── transcripts/         ← meeting notes, podcast/video transcripts
│   ├── data/                ← CSV, JSON, benchmarks
│   └── assets/              ← downloaded images
│
├── wiki/                    ← LLM-owned generated content
│   ├── index.md             ← master catalog (read first on every query)
│   ├── log.md               ← append-only activity log
│   ├── hot.md               ← ~500-word session hot cache
│   ├── overview.md          ← high-level synthesis
│   ├── sources/             ← summary-{slug}.md per ingested source
│   ├── entities/            ← people, companies, products, models
│   ├── concepts/            ← ideas, methods, theories
│   ├── comparisons/         ← analytical comparisons (filed from queries)
│   └── syntheses/           ← longer essays/analyses
│
└── .claude/skills/          ← custom slash commands
    ├── my-world.md  today.md  close.md
    └── trace.md  ghost.md  recall.md
```

## The three operations

The LLM agent supports three core operations defined in `CLAUDE.md`:

- **`ingest raw/path/to/file`** — Read a source, summarize it, create a `wiki/sources/` page, update or create relevant `wiki/concepts/` and `wiki/entities/` pages, flag contradictions, and append to `wiki/log.md`. A single ingest typically touches 5–15 wiki pages.
- **`query <question>`** — Read `wiki/index.md`, identify relevant pages, synthesize an answer with `[[wiki-link]]` citations. Valuable answers can be filed back as `wiki/comparisons/` or `wiki/syntheses/` pages.
- **`lint`** — Health check: list contradictions, orphan pages, missing concept pages, stale claims, and suggest new investigations.

See `CLAUDE.md` for the full schema and workflows.

## Quick start

### 1. Clone the repo

```bash
git clone <repo-url> ai-wiki
cd ai-wiki
```

### 2. Install Obsidian and open the vault

- Download [Obsidian](https://obsidian.md).
- File → Open Vault → select this directory.
- Install community plugins **Dataview** and **Templater** (Settings → Community plugins → Browse).
- Optional: install the [Obsidian Web Clipper](https://obsidian.md/clipper) browser extension and configure the clip destination to `raw/articles/`.

### 3. Set up CLI tools (conda)

The CLI tools are managed in a conda environment so collaborators get the same setup:

```bash
# Create the env
conda env create -f environment.yml

# Activate it
conda activate ai-wiki

# Install the npm-based CLI tools (defuddle, qmd)
bash scripts/setup-cli-tools.sh
```

This installs:

| Tool | Purpose |
| :--- | :--- |
| **[defuddle](https://github.com/kepano/defuddle)** | Strips ads/nav/chrome from web pages so ingest reads ~3,000 fewer tokens per article |
| **[qmd](https://github.com/tobiloo/qmd)** | Hybrid BM25 + semantic + LLM-rerank search across the wiki (used by the `/recall` slash command) |

### 4. Set up Claude Code

Open Claude Code in the vault root. `CLAUDE.md` is auto-loaded as the master schema. The agent will read `wiki/hot.md` silently at the start of every session.

### 5. First ingest

Drop a source into `raw/`:

```bash
# Example: clip a clean version of an article via defuddle
defuddle https://example.com/some-article --md > raw/articles/some-article.md
```

Then in Claude Code:

```
ingest raw/articles/some-article.md
```

The agent will create a summary page, update relevant concept/entity pages, and append to the activity log.

## How to contribute

1. **Curate sources, not wiki pages.** Drop new sources into `raw/`, then run `ingest`. Avoid hand-editing `wiki/` pages — let the agent maintain consistency. (Exception: small typo fixes are fine.)
2. **One source at a time.** Karpathy's preference. Staying involved during ingest produces richer cross-referencing and catches errors.
3. **Commit after every ingest.**
   ```bash
   git add wiki/ raw/ && git commit -m "ingest: <source title>"
   ```
4. **Run `lint` weekly** to catch contradictions, orphan pages, and stale claims.
5. **Never write to `raw/` from the agent.** It is the source of truth.
6. **Use `[[wikilinks]]`**, never markdown links — Obsidian's graph view depends on them.

## Custom slash commands

Defined in `.claude/skills/`:

| Command | When to use |
| :--- | :--- |
| `/my-world` | New session — get a briefing on current focus, recent activity, and open questions |
| `/today` | Morning — get 3 priority focuses for the day |
| `/close` | End of session — summarize, persist state to `wiki/hot.md` |
| `/trace [concept]` | Trace how a concept's coverage evolved across the wiki |
| `/ghost [draft]` | Draft text in your own voice using your wiki notes as samples |
| `/recall [topic]` | Pre-load relevant wiki pages before answering a new topic |

## Acknowledgements

- [Andrej Karpathy](https://karpathy.ai/) for the LLM Wiki idea file.
- [ScrapingArt/Karpathy-LLM-Wiki-Stack](https://github.com/ScrapingArt/Karpathy-LLM-Wiki-Stack) for the comprehensive blueprint this vault implements.
- [Steph Ango (Kepano)](https://stephango.com/) for `defuddle` and the official Obsidian agent skills.
- [Tobi Lütke](https://tobi.lutke.com/) for `qmd`.

## License

TBD.
