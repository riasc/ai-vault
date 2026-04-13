# /my-world

## Purpose
Provide a session briefing at the start of a new conversation. Restores operating context so we don't waste turns recapping.

## Workflow
1. Read `wiki/hot.md` silently (already required by CLAUDE.md, but re-confirm).
2. Read `wiki/index.md` for the current catalog.
3. Read the last 10 entries from `wiki/log.md`:
   `grep "^## \[" wiki/log.md | tail -10`
4. Briefly tell the user:
   - What we are currently focused on (from `hot.md`).
   - What was last ingested / queried / linted.
   - Any open questions or contradictions outstanding.
   - 1–2 suggested next actions.
5. Wait for direction.

## When to Use
At the start of a fresh session, especially after time away from the vault.
