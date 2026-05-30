---
name: notion-dev-ssot
description: Bootstrap a project with Notion as development SSOT — create or adopt private task/docs databases, generate AGENTS.md and .ssot/config.json, and install project-scoped workflow skills. Use when the user asks to set up Notion SSOT, connect a dev task board, create AGENTS.md for a repo, project bootstrap with Notion, or "개발 태스크 보드 연결", "Notion SSOT 세팅".
---

# notion-dev-ssot

**Single entry skill** for bootstrapping a repository with Notion as development SSOT. Detailed procedures live in `references/` — read them with the Read tool before acting.

## When to use

- "프로젝트 Notion SSOT 세팅해줘"
- "AGENTS.md 만들어줘" (with Notion task/docs workflow)
- "개발 태스크 보드 연결"
- "Notion development SSOT bootstrap"
- "project bootstrap with Notion"

## Prerequisites (every route)

1. Confirm **Notion MCP** is connected. If not, stop and tell the user to enable the Notion workspace plugin — do not guess database IDs or URLs.
2. Confirm the **target repository path** (default: current workspace root).

## Routing

Read the matching reference **before** any Notion write or target-repo file creation:

| User intent | Read |
|---|---|
| New project SSOT setup (default) | `references/init/wizard.md` |
| Connect existing Notion databases by URL | `references/init/adopt-existing.md` |
| Validate task/docs schema only | `references/init/verify-schema.md` |

If intent is ambiguous, ask once: create new private databases vs adopt existing URLs.

## Bundled assets (read paths from wizard)

| Asset | Path under this skill |
|---|---|
| Tasks DB DDL | `references/schemas/tasks-database.ddl` |
| Docs DB DDL | `references/schemas/docs-database.ddl` |
| Relation setup | `references/schemas/relations-setup.md` |
| Blueprint seed body | `references/schemas/seed-blueprint.md` |
| AGENTS template | `references/templates/AGENTS.md.tpl` |
| Config template | `references/templates/config.json.tpl` |
| Workflow skills to copy | `references/bundled/cursor-skills/` |

## Safety rules

- Get **explicit user approval** before any Notion create/update or overwriting target `AGENTS.md`.
- On adopt mode, run schema verification first; do not auto-ALTER Notion schema without user consent.
- Do not set Notion tasks to `완료` unless the user asked.

## After bootstrap

Tell the user:

1. Notion Tasks + Docs database URLs
2. Paths written in the target repo (`AGENTS.md`, `.ssot/config.json`, workflow skills)
3. Next step: open the target repo and run development work through AGENTS.md Development router
