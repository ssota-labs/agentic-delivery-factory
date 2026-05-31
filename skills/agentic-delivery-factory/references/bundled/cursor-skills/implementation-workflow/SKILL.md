---
name: {{PROJECT_SLUG}}-implementation-workflow
description: Implement or verify {{PROJECT_NAME}} work from Notion tasks (작업 유형 구현/검증). Use after AGENTS.md routes work to implementation. Follow AGENTS.md for coding conventions; this skill covers intake, gate, execution, close-out, and task lifecycle.
---

# {{PROJECT_NAME}} Implementation Workflow

**Coding conventions** live in **`AGENTS.md`**. This skill covers YouPD-style task-driven procedure.

## Prerequisites

- AGENTS.md request intake gate completed.
- Task row loaded or created; linked goal present for non-trivial work.
- Linked nodes/edges read when the task creates or changes durable output.
- Task `작업 유형` is `구현` or `검증` (or user explicitly requested implementation).
- Run mode identified: interactive chat or scheduler automation.

## Progressive references

- [references/implementation-gate.md](references/implementation-gate.md)
- [references/close-out.md](references/close-out.md)

## Workflow

### 0. Intake

Before editing code or docs:

1. Decide whether a Knowledge Node is required.
2. Decide whether a Task row is required.
3. If no task exists and the work is non-trivial, create one via `{{PROJECT_SLUG}}-task-workflow`.
4. Link `관련 노드` / `관련 엣지` before or during implementation.

### 1. Pick up

- Set task `상태 = 진행중` when starting work.
- Set `진행일` as datetime (`date:진행일:is_datetime=1`).
- Do not plan from the task title alone.

### 2. Gate

Run [references/implementation-gate.md](references/implementation-gate.md). If blocked, stop and use the blocker template there.

### 3. Read context

- Linked `관련 노드` contracts and `관련 엣지` dependencies.
- `README.md`, `AGENTS.md`, `.adf/config.json`, and relevant repo paths.
- Predecessor tasks through `선행 작업` / `후행 작업`.

### 4. Plan

Summarize task ID, dependency status, files to touch, verification commands, node/edge updates, and risks.

### 5. Execute

Follow AGENTS.md setup/testing/code style sections. Update linked node contracts when repo behavior changes.

### 6. Close-out

Follow [references/close-out.md](references/close-out.md): verify, record node/edge changes, reconcile delta, report, and apply the completion rule for the current run mode.
