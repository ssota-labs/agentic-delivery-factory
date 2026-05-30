# AGENTS.md

Instructions for AI coding agents working in **{{GITHUB_REPO}}**.

## Project Overview

**{{PROJECT_NAME}}** — {{PROJECT_OVERVIEW}}

Machine-readable SSOT config: [`.ssot/config.json`](.ssot/config.json).

---

## Development SSOT: Notion

**Notion is the source of truth for how we build this project.** The repository holds the code; Notion holds decisions, specs, policies, guides, and task state.

### Development router (read first)

For **any** development request (work, reconciliation, new version, docs, implementation), start here.

#### Step 0 — Notion (mandatory)

1. Confirm **Notion MCP** is connected. If not, stop — do not plan or code from memory.
2. Load context from the [development task database]({{TASKS_DB_URL}}):
   - User named a task/version → fetch that row.
   - Otherwise → identify in-progress or next eligible row; confirm in one line before proceeding.
3. Document database: [{{DOCS_DB_URL}}]({{DOCS_DB_URL}})

#### Step 1 — Classify intent

| User / scheduler says | Intent | Read skill |
|---|---|---|
| 정합성 체크, reconciliation, drift audit | `reconcile` | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-reconciliation/SKILL.md` |
| 작업 진행, continue task, implement, {{TASK_PREFIX}}-* | `work` | See Step 2 |
| 새 버전, milestone setup, task template | `bootstrap-version` | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-version-bootstrap/SKILL.md` |

**Reconcile default scope:** entire development task database (all `상태`), repo `main` at current HEAD — unless the user narrowed scope in chat.

#### Step 2 — `work` branch

Use the loaded task's `작업 유형` and title:

| Route | Read skill |
|---|---|
| PRD 작성, 설계 작성, 상세 로드맵 작성; Blueprint / Policy / ADR / dedicated Spec | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-documentation-workflow/SKILL.md` |
| 구현, 검증 | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-implementation-workflow/SKILL.md` |

**Small Spec/Policy patches** (single topic, same PR) → implementation skill Close-out, not documentation skill.

#### `work` → 구현/검증

Use sections below (Setup, Development Workflow, Testing, Code Style) before editing code. Run the gate in `{{PROJECT_SLUG}}-implementation-workflow` (`references/implementation-gate.md`).

### Search before you build

Search Notion for related tasks, ADRs, specs, and policies before creating duplicates.

### Notion docs and task board

- **Docs DB:** [{{DOCS_DB_URL}}]({{DOCS_DB_URL}}) — load documentation workflow skill when writing documents.
- **Tasks:** `상태` `대기`/`진행중`/`보류`/`완료`/`취소`; `작업 유형` PRD/설계/구현/검증/로드맵. Pick up → `진행중`; blocked → `보류`. Link outputs via `관련 문서`. **Do not** set `완료` unless the user asked — propose only.
- Record durable outcomes (decisions, contracts, policies); skip typo-only noise.

---

{{FULL_PROFILE_SECTIONS}}

## Related workflow skills

| Skill | Path |
|---|---|
| Documentation | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-documentation-workflow/SKILL.md` |
| Implementation | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-implementation-workflow/SKILL.md` |
| Reconciliation | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-reconciliation/SKILL.md` |
| Version bootstrap | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-version-bootstrap/SKILL.md` |

When in doubt about task naming or doc types, follow the Blueprint in the docs database and linked PRD/D3 for the current milestone.
