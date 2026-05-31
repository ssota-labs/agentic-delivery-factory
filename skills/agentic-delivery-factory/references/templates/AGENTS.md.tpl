# AGENTS.md

Instructions for AI agents working in **{{GITHUB_REPO}}**.

## Project Overview

**{{PROJECT_NAME}}** — {{PROJECT_OVERVIEW}}

Machine-readable ADF config: [`.adf/config.json`](.adf/config.json).

## Delivery SSOT: Notion Knowledge Graph

Notion is the source of truth for goals, planning, decisions, node documents, graph relationships, and task state. The repository holds implementation artifacts.

| Database | URL |
|---|---|
| Project | {{PROJECT_URL}} |
| Goals | {{GOALS_DB_URL}} |
| Catalog | {{CATALOG_DB_URL}} |
| Nodes | {{NODES_DB_URL}} |
| Edges | {{EDGES_DB_URL}} |
| Tasks | {{TASKS_DB_URL}} |

## Agent Router

For any substantive request, start by loading Notion context.

1. Confirm Notion MCP/tools are available. If not, do repo-only work and report exact Notion updates still needed.
2. Load the task row if the user named `{{TASK_PREFIX}}-*`; otherwise identify the active/next task.
3. Load linked goals, nodes, and edges before writing code or docs.

| User intent | Read skill |
|---|---|
| Task pickup/status/plan | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-task-workflow/SKILL.md` |
| Node document create/update | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-node-authoring/SKILL.md` |
| Edge creation/graph relation | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-edge-workflow/SKILL.md` |
| Implementation/verification | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-implementation-workflow/SKILL.md` |
| Reconciliation/drift audit | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-reconciliation/SKILL.md` |

## Node Rules

- Every durable concept or contract should have a Knowledge Node.
- Use stable `키` values: `{{PROJECT_SLUG}}.<area>.<topic>`.
- Set `타입`, `카테고리`, `범위`, `상태`, and `요약`.
- Create edges for important dependencies and definitions.
- Use native select `카테고리` for board grouping.

## Task Rules

- `상태`: `대기` / `진행중` / `보류` / `완료` / `취소`.
- Every non-trivial task should link to at least one `목표`.
- Do not set `완료` unless the user explicitly asks.
- Implementation tasks should link relevant `관련 노드`; graph tasks should link `관련 엣지`.

{{FULL_PROFILE_SECTIONS}}
