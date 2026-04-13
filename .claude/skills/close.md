# /close

## Purpose
End-of-session wrap-up. Persist the session state into `wiki/hot.md` and `wiki/log.md` so the next session can resume cleanly.

## Workflow
1. Summarize what happened in this session in 3–5 bullets.
2. Identify any key decisions or conclusions reached.
3. Identify any unresolved questions or follow-ups.
4. **Overwrite** `wiki/hot.md` with the standard structure:
   - Current Focus
   - Open Questions
   - Recent Decisions
   - Last Operations (last 3–5 lines from `wiki/log.md`)
   - Active Pages
   - Keep the file under 500 words.
5. If any ingest / query / lint operations happened that were not yet logged, append them to `wiki/log.md` now.
6. Confirm the wrap-up to the user briefly.

## When to Use
At the end of a session, before stepping away from the vault.
