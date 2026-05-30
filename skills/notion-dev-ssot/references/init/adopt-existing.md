# Adopt existing Notion databases

Use when the user already has task/docs databases and only needs **AGENTS.md**, **`.ssot/config.json`**, and **workflow skills** in the target repo.

## Phase 0 — Collect inputs

Same as [wizard.md](wizard.md) Phase 0, except Notion mode = `adopt`:

| # | Field |
|---|---|
| 1–5 | Target path, slug, name, prefix, githubRepo |
| 6 | **Tasks database URL** |
| 7 | **Docs database URL** |
| 8 | AGENTS profile (`minimal` / `full`) |
| 9 | Skills install dir |

## Phase 1 — Fetch and verify

1. `notion-fetch` Tasks URL → `TASKS_DS_ID`, canonical URL
2. `notion-fetch` Docs URL → `DOCS_DS_ID`, canonical URL
3. Run [verify-schema.md](verify-schema.md) on both

If verification reports **missing required properties**, stop and show the diff. Options for user:

- Fix Notion manually to match expected schema
- Grant permission to run `notion-update-data-source` ALTER (list exact DDL from verify output)
- Abort

Do **not** silently alter production databases.

## Phase 2 — Write target repo

Same as wizard Phase 2–3 with resolved URLs and IDs.

Skip Notion database creation and relation setup unless verify found missing relations and user approved fixes.

## Phase 3 — Report

Same as wizard Phase 4, noting mode = **adopt**.
