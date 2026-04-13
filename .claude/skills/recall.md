# /recall

## Purpose
Pre-load relevant wiki context before responding to a new topic. Reduces hallucination and grounds answers in what the wiki already knows.

## Workflow
1. Take the user's query or topic as input.
2. If `qmd` is installed, run: `qmd query "{topic}" --json`, parse the response, and extract the top 5 file paths.
3. If `qmd` is not installed, fall back to:
   - Read `wiki/index.md`
   - Identify the 5 most relevant pages by title and one-line summary
4. Read each of those wiki pages.
5. Briefly summarize what the wiki already knows about this topic.
6. Then proceed to answer the user's question with that context loaded.

## When to Use
At the start of any new session topic, or whenever the conversation shifts to a subject the wiki may already cover.

## Notes
- Install `qmd` for hybrid BM25 + semantic + LLM-rerank search: `npm install -g @tobilu/qmd` then `qmd collection add ./wiki --name ai-wiki`.
- Until `qmd` is installed, this skill operates in fallback mode using `wiki/index.md`.
