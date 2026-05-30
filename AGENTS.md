# AGENTS.md

Instructions for AI coding agents working in **ssota-labs/notion-dev-ssot**.

## Project Overview

**notion-dev-ssot** is a skills.sh-distributable agent skill package. It bootstraps **other** repositories with:

- Notion as **development SSOT** (task database + docs database)
- Generated `AGENTS.md` and `.ssot/config.json` in the target project
- Project-scoped workflow skills under `.cursor/skills/{projectSlug}-*`

This repo does **not** ship application runtime code. The shipped artifact lives under `skills/notion-dev-ssot/`.

## Directory layout

```text
skills/notion-dev-ssot/
  SKILL.md                    # Router (always loaded when skill invoked)
  references/
    init/                     # Bootstrap procedures
    schemas/                  # Notion DDL + relation setup
    templates/                # AGENTS.md.tpl, config.json.tpl
    bundled/cursor-skills/    # Source files copied into target projects
```

On install via skills.sh, only `skills/` ships to the user's agent environment.

## Placeholder convention

Bundled templates and workflow skills use these placeholders. The init wizard replaces them when copying into a target repo:

| Placeholder | Meaning |
|---|---|
| `{{PROJECT_SLUG}}` | kebab-case slug (folder names, skill prefix) |
| `{{PROJECT_NAME}}` | Human display name |
| `{{TASK_PREFIX}}` | Task ID prefix (e.g. `YPDS`) |
| `{{GITHUB_REPO}}` | `org/repo` on GitHub |
| `{{TASKS_DB_URL}}` | Notion tasks database URL |
| `{{TASKS_DS_ID}}` | Tasks data_source_id |
| `{{DOCS_DB_URL}}` | Notion docs database URL |
| `{{DOCS_DS_ID}}` | Docs data_source_id |
| `{{SKILLS_INSTALL_DIR}}` | `.cursor/skills` or `.agents/skills` |

Never commit real Notion URLs into bundled source files — only into generated target project files.

## Development workflow

1. Edit `skills/notion-dev-ssot/SKILL.md` only for routing changes (keep ≤200 lines).
2. Put detailed procedures in `references/**` (progressive disclosure).
3. When changing bundled workflow skills, keep placeholders consistent across all four skills.
4. Test init flow manually per README checklist after substantive changes.

## Pull request guidelines

- Title: `[notion-dev-ssot] Brief description`
- Do not edit merged placeholder examples with real workspace IDs
- Verify `grep -r '{{PROJECT_SLUG}}' skills/notion-dev-ssot/references/bundled` still finds expected template markers

## Related files

| File | Why |
|---|---|
| `skills/notion-dev-ssot/SKILL.md` | End-user / agent router |
| `skills/notion-dev-ssot/references/init/wizard.md` | Full bootstrap procedure |
| `skills/notion-dev-ssot/references/templates/AGENTS.md.tpl` | Target project AGENTS template |
| `README.md` | Human install + init instructions |
