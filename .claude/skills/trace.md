# /trace

## Purpose
Trace how understanding of a concept evolved across the wiki. Useful for spotting drift, contradictions, or growth in coverage.

## Workflow
1. Take the concept name as input (e.g. `/trace mixture-of-experts`).
2. Find all wiki pages that mention the concept (search `wiki/` for the term and any aliases).
3. For each match, note:
   - The page type (source / concept / entity / comparison / synthesis)
   - The page's `created` and `updated` dates
   - The relevant claim or section
4. Order findings chronologically by ingest / update date.
5. Present a timeline of how the concept has been discussed and refined.
6. Flag any contradictions or shifts in claims across time.

## When to Use
When you want to understand the lineage of an idea in the wiki, or audit it for consistency.
