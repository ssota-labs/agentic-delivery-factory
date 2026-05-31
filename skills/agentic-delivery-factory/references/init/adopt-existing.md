# Adopt existing Notion databases

Use when the user already has Goals, Catalog, Nodes, Edges, and Tasks databases and only needs **AGENTS.md**, **`.adf/config.json`**, and **workflow skills** in the target repo.

## Phase 0 — Collect inputs

Same as [wizard.md](wizard.md) Phase 0, except Notion mode = `adopt`:

| # | Field |
|---|---|
| 1–5 | Target path, slug, name, prefix, githubRepo |
| 6 | Project page URL |
| 7 | Goals database URL |
| 8 | Catalog database URL |
| 9 | Nodes database URL |
| 10 | Edges database URL |
| 11 | Tasks database URL |
| 12 | Skills install dir |

## Phase 1 — Fetch and verify

1. `notion-fetch` each database URL and record canonical URL + data source ID.
2. Run [verify-schema.md](verify-schema.md) against Goals, Catalog, Nodes, Edges, and Tasks.
3. If required properties or relations are missing, stop and show the diff.

Do **not** silently alter production databases. Apply `notion-update-data-source` only after user approval with exact DDL.

## Phase 2 — Write target repo

Same as wizard Phase 2–3 with resolved URLs and IDs.

Skip Notion database creation and relation setup unless verification found missing relations and user approved fixes.

## Phase 3 — Report

Same as wizard Phase 4, noting mode = **adopt**.
