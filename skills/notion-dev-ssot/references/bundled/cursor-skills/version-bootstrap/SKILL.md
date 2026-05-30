---
name: {{PROJECT_SLUG}}-version-bootstrap
description: Bootstrap a new {{PROJECT_NAME}} version on the Notion development task board — {{TASK_PREFIX}}-Px.x rows (PRD, DSGN, IMPL, VERF), relations, optional doc placeholders. Use when the user asks to add a new version or milestone task setup.
---

# {{PROJECT_NAME}} Version Bootstrap

Create **Notion task structure** only — no `main` code edits.

## Prerequisites

- AGENTS.md Development router (Notion MCP, intent = `bootstrap-version`).
- Version id agreed (e.g. `P1.5`); read phase Blueprint in docs DB for topic title.

Tasks DB: [{{TASKS_DB_URL}}]({{TASKS_DB_URL}})  
Docs DB: [{{DOCS_DB_URL}}]({{DOCS_DB_URL}})

## Workflow

1. Confirm predecessor milestone (`P1.(x-1)` IMPL `완료` or explicitly waived).
2. Create rows below; `상태` = `대기`, set `Blocked by` / `종속성`.
3. Optionally create empty PRD/D3 in docs DB; link `관련 문서`.
4. Report task IDs; suggest first work → usually `{{TASK_PREFIX}}-P1.x-PRD` via documentation skill (unless Blueprint missing).

Do not set any task `완료`.

## Task templates

Replace `P1.x` with target version.

| Task ID | `작업 유형` | Typical `Blocked by` |
|---|---|---|
| `{{TASK_PREFIX}}-P1.x-PRD` | PRD 작성 | Blueprint / prior VERF |
| `{{TASK_PREFIX}}-P1.x-DSGN` | 설계 작성 | `{{TASK_PREFIX}}-P1.x-PRD` |
| `{{TASK_PREFIX}}-P1.x-IMPL` | 구현 | `{{TASK_PREFIX}}-P1.x-DSGN` + predecessor IMPL |
| `{{TASK_PREFIX}}-P1.x-VERF` | 검증 | `{{TASK_PREFIX}}-P1.x-IMPL` |

**Relations**

- DSGN after PRD `완료` or accepted draft
- IMPL: PRD + D3 in `관련 문서` before `진행중`
- VERF description: run full [{{PROJECT_SLUG}}-reconciliation](../{{PROJECT_SLUG}}-reconciliation/SKILL.md) after impl

**Optional doc placeholders**

| Page | `태그` | Notes |
|---|---|---|
| `{{PROJECT_NAME}} P1.x 기획안 — {topic}` | PRD | Use workspace PRD template if available |
| `{{PROJECT_NAME}} P1.x 설계문서 — {topic}` | 설계 | Use workspace design template if available |
