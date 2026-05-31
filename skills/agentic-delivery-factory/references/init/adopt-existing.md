# Adopt existing Notion databases

Use when the user already has Goals, Catalog, Nodes, Edges, and Tasks databases and only needs **AGENTS.md**, **`.adf/config.json`**, and **workflow skills** in the target repo.

## Phase 0 — Collect inputs

Same as [wizard.md](wizard.md) Phase 0, except Notion mode = `adopt`:

| # | Field |
|---|---|
| 1–7 | Target path, slug, name, prefix, githubRepo, integrationBranch, releaseBranch |
| 8 | Project page URL |
| 9 | Goals database URL |
| 10 | Catalog database URL |
| 11 | Nodes database URL |
| 12 | Edges database URL |
| 13 | Tasks database URL |
| 14 | Skills install dir |

## Phase 1 — Fetch and verify

1. `notion-fetch` each database URL and record canonical URL + data source ID.
2. Run [verify-schema.md](verify-schema.md) against Goals, Catalog, Nodes, Edges, and Tasks.
3. Apply [../catalog/migrations.md](../catalog/migrations.md) when `catalogMigrationVersion` is missing or older than the shipped bootstrap version.
4. If required properties or relations are missing, stop and show the diff.

Do **not** silently alter production databases. Apply `notion-update-data-source` only after user approval with exact DDL.

## Phase 2 — Write target repo

Same as wizard Phase 2–3 with resolved URLs and IDs.

Skip Notion database creation and relation setup unless verification found missing relations and user approved fixes.

## Phase 3 — Install automations and report

Same as wizard Phase 4–5, noting mode = **adopt**.
