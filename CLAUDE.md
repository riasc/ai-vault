# LLM Wiki — Master Schema

## Domain
AI/ML research, recent technologies, and learning material. Emphasis on understanding concepts (architectures, training, inference), tracking model families and tools, and accumulating notes from papers, articles, and tutorials.

## Project Structure
- `raw/` — immutable source documents. **NEVER modify any file in `raw/`.**
- `wiki/` — LLM-generated wiki. You own this layer entirely.
- `wiki/index.md` — master catalog. Update on EVERY ingest.
- `wiki/log.md` — append-only activity log. Never delete entries.
- `wiki/overview.md` — high-level synthesis. Revise after major ingests.
- `wiki/hot.md` — session hot cache (~500 words). Read silently at session start BEFORE responding.
- `CLAUDE.md` — this file. Re-read at the start of every session.

## Hot Cache (`wiki/hot.md`)
Read `wiki/hot.md` silently at the start of EVERY session, before responding. This file contains ~500 words of recent session context. Do not summarize it to the user — just use it to restore your operating context.

After every session (or when the user says `/close`), update `wiki/hot.md`:
- Keep total length under 500 words.
- Overwrite (do not append).
- Structure:

```
### Current Focus
[1–2 sentences: what we are actively investigating right now]

### Open Questions
[Bullet list of unresolved questions or next ingests to do]

### Recent Decisions
[Bullet list: key decisions or conclusions from the last 1–2 sessions]

### Last Operations
[3–5 lines from wiki/log.md — the most recent ingest/query/lint entries]

### Active Pages
[List of wiki pages currently being developed or recently updated]
```

`wiki/hot.md` is the **only** wiki file you may write without an explicit ingest/query/lint trigger.

## Page Conventions
Every wiki page MUST have YAML frontmatter. Use these schemas:

### Source Summary Pages (`wiki/sources/`)
```yaml
---
type: source
title: "Article/Paper Title"
slug: summary-{slug}
source_file: raw/articles/{filename}.md
author: "Author Name"
date_published: YYYY-MM-DD
date_ingested: YYYY-MM-DD
key_claims:
  - claim1
  - claim2
  - claim3
related: [[concept1]], [[concept2]]
confidence: high | medium | low
---
```

### Concept Pages (`wiki/concepts/`)
```yaml
---
type: concept
title: "Concept Name"
aliases: [alt-name, abbreviation]
sources:
  - [[source1]]
  - [[source2]]
related:
  - [[concept2]]
  - [[entity1]]
created: YYYY-MM-DD
updated: YYYY-MM-DD
confidence: high | medium | low
---
```

### Entity Pages (`wiki/entities/`)
```yaml
---
type: entity
entity_type: person | company | product | org | model
title: "Entity Name"
sources:
  - [[source1]]
  - [[source2]]
related:
  - [[concept1]]
  - [[entity2]]
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

### Comparison Pages (`wiki/comparisons/`)
```yaml
---
type: comparison
title: "Comparing X vs Y"
sources:
  - [[source1]]
  - [[source2]]
filed_from_query: true
date: YYYY-MM-DD
---
```

### Synthesis Pages (`wiki/syntheses/`)
```yaml
---
type: synthesis
title: "Synthesis Title"
sources:
  - [[source1]]
  - [[source2]]
filed_from_query: true
date: YYYY-MM-DD
---
```

## Page Body Templates

Every page follows a fixed section layout below its frontmatter. Skip sections that don't apply to a given page (do not write a section just to fill it), but do not invent new top-level sections — if you need to add one that isn't in the template, update this file first so future sessions stay aligned.

### Concept Page Body

```markdown
# {Concept Name}

## Definition
One or two plain-language sentences: what this thing *is*, mechanically. A reader should understand the concept from this section alone before reading further.

## Intuition
The problem it solves, the core insight, and why this concept exists. Paragraph form. This is where you explain the "aha" — what makes this concept interesting relative to what came before.

## Formulation
Math, pseudo-code, or precise mechanical description. Use LaTeX via `$...$` for inline and `$$...$$` for display. Omit the section if the concept is too abstract for a formulation (e.g. a broad umbrella concept).

## Variants
Subspecies, generalizations, alternative implementations, or named members of a family. Bulleted.

## Tradeoffs
Limitations, failure modes, when not to use, complexity costs, scaling issues. Honest downsides go here, not buried elsewhere.

## History & Lineage
Where it came from (predecessors, motivating prior work) and what came after (descendants, successors, displacements). Can link forward to concepts not yet ingested.

## Figures
Obsidian `![[...]]` embeds with brief captions. Omit if the concept has no load-bearing figure.

## Sources
- [[source1]]
- [[source2]]
```

### Entity Page Body

```markdown
# {Entity Name}

## What / Who
One or two sentences: role, affiliation, what this entity is. For a person: their role and institutional context. For an org: what they do. For a benchmark, dataset, or product: what it is and what it measures/provides.

## Significance
Why this entity matters to the wiki's domain. The concrete contribution, role, or position. For people, this is where claims-to-fame go. For orgs, institutional relevance. For benchmarks, what they're used to measure and by whom.

## Timeline / Notable Work
Key dates, publications, products, or decisions, bulleted. Keep it short — this page should grow as more sources arrive, not on the first mention.

## Relationships
Wikilinks to closely-related entities and concepts, with a one-line note on the relationship.

## Sources
- [[source1]]
- [[source2]]
```

### Source Summary Page Body

```markdown
# {Source Title}

**{Author line}** — {venue}, {year}. {One-line hook describing what this source does or argues.}

## Abstract
A paraphrase of the source's own abstract or thesis. Do not copy verbatim — summarize in your own words so future sessions can quote safely.

## Key Contributions
Numbered list of the main claims or contributions, each with a wikilink to the relevant concept page.

## Method
What the source actually does — architecture, experimental setup, methodology, dataset, or argument structure. The "how."

## Results
Empirical findings, headline numbers, tables (reproduce small ones inline), charts. Use concrete numbers, not vague descriptions.

## Discussion
The source's own interpretation of its results — ablations, caveats, limitations the authors acknowledge, failure cases.

## Figures
Embedded figures with brief captions. Use `![[...]]` syntax.

## Historical Context
How this source fits into the broader timeline of the field. What it responds to, what it enables, which later work builds on it. This is often the highest-value section for cross-referencing.

## Provenance
- **Source file:** `raw/papers/{filename}` (or similar)
- **Version / arXiv ID:** if applicable
- **License / copyright notes:** any reproduction grants or restrictions worth recording for future ingests

## Related
Wikilinks to all concept, entity, and other source pages that connect to this source.
```

### Comparison & Synthesis Page Bodies

For `wiki/comparisons/` and `wiki/syntheses/` pages (filed from query answers), follow the same spirit: open with a Definition-equivalent framing sentence, then a clearly labeled body, then a `## Sources` section with wikilinks. These pages are more free-form because they answer specific questions, but they should still always start with a clear framing and end with source citations.

## Wikilink Syntax
Use Obsidian wikilinks (`[[Page Title]]`), not standard markdown links (`[text](path.md)`). Standard markdown links break Obsidian's graph view and backlink engine.

## Ingest Workflow
When the user says `ingest [filename]` or `ingest raw/[path]`:
1. Read the source file from `raw/`.
2. Discuss key takeaways with the user (3–5 bullet points).
3. Create `wiki/sources/summary-{slug}.md` with a full summary using the source frontmatter schema.
4. Update `wiki/index.md` — add the new page with a one-line summary.
5. Update ALL relevant concept and entity pages with new information.
6. If new info contradicts an existing page, flag it explicitly and demote the affected page's `confidence` to `low`.
7. Create new concept/entity pages if the source introduces them.
8. Append a structured entry to `wiki/log.md` (see Log Format below).
9. A single ingest should typically touch 5–15 wiki pages.

## Query Workflow
When the user asks a question:
1. Read `wiki/index.md` to identify relevant pages.
2. Read those pages directly.
3. Synthesize an answer with `[[wiki-link]]` citations.
4. If the answer is a valuable analysis, offer to file it as a new page in `wiki/comparisons/` or `wiki/syntheses/`.
5. Update `wiki/log.md` with a query entry.

## Lint Workflow
When the user says `lint` or `health check`:
1. Scan for contradictions between pages. List them with file paths and the conflicting claims.
2. Find orphan pages (no inbound links). List them.
3. List concepts mentioned 3+ times across pages but lacking their own page.
4. Check for stale claims that newer sources may have superseded.
5. Check for broken `[[wikilinks]]` — links whose target page does not exist. List the source page and the dangling link.
6. Suggest 3–5 new questions or sources to investigate.
7. Append a lint entry to `wiki/log.md`.

## Working With Images
Markdown sources with inline images cannot be processed in a single pass — you must read the text first and then view referenced images separately.

- Images live under `raw/assets/` (Obsidian's Web Clipper + "Download attachments for current file" hotkey will place them there automatically).
- On ingest of an image-heavy source: (1) read the source's text, (2) identify which referenced images are load-bearing for the claims you are summarizing, (3) view those images with the Read tool using their `raw/assets/...` path, (4) incorporate what they show into the summary and any updated concept pages.
- When an image is critical to a concept (diagram, chart, architecture figure), reference the asset path in the relevant wiki page so future sessions can re-view it.
- Never copy images into `wiki/` — reference them from their `raw/assets/` location, since `raw/` is the source of truth.

## Log Format
Each log entry MUST start with this prefix for parsability:

```
## [YYYY-MM-DD] {ingest|query|lint} | {title/description}
```

Example:
```
## [2026-04-12] ingest | Mixture of Experts Efficiency Study
Source: raw/articles/2026-04-moe-efficiency.md
Pages created: wiki/sources/summary-moe-efficiency.md
Pages updated: wiki/concepts/mixture-of-experts.md, wiki/concepts/scaling-laws.md
Contradictions flagged: wiki/concepts/dense-vs-sparse.md (see note)
```

## Safety Rules
- **NEVER write to `raw/`.** This is a hard constraint with no exceptions.
- **NEVER delete wiki pages.** Mark as deprecated in frontmatter instead.
- Always update `wiki/index.md` and `wiki/log.md` on every operation.
- When uncertain about a claim's accuracy, set `confidence: low`.
- Cross-reference all new pages to at least 2 existing pages where possible.
- Use `[[wikilinks]]`, never `[text](path.md)` markdown links.
- Do not write to `wiki/` outside of an ingest/query/lint operation, except for `wiki/hot.md` updates.

## Division of Labour
| Human (you) | LLM (me) |
| :--- | :--- |
| Curate sources into `raw/` | Summarize and extract |
| Direct analysis | Cross-reference and file |
| Ask good questions | Maintain consistency |
| Decide what to explore next | Flag contradictions, suggest investigations |
