---
name: {{PROJECT_SLUG}}-implementation-workflow
description: Implement or verify {{PROJECT_NAME}} code from Notion tasks (작업 유형 구현/검증). Use after AGENTS.md routes work to implementation. Follow AGENTS.md for coding conventions; this skill covers gate, plan, close-out, and small node/policy updates.
---

# {{PROJECT_NAME}} Implementation Workflow

**Coding conventions** live in **`AGENTS.md`**. This skill covers procedure only.

## Prerequisites

- AGENTS.md router completed: task row loaded, linked nodes/edges read.
- Task `작업 유형` is `구현` or `검증` (or user explicitly requested implementation).

## Progressive references

- [references/implementation-gate.md](references/implementation-gate.md)
- [references/close-out.md](references/close-out.md)

## Workflow

### 1. Gate

Run [references/implementation-gate.md](references/implementation-gate.md). If blocked, stop and use the blocker template there.

### 2. Read context

- Linked `관련 노드` contracts and `관련 엣지` dependencies.
- `README.md`, `AGENTS.md`, and relevant repo paths.
- Predecessor tasks through `선행 작업` / `종속성`.

Do not plan from the task row alone.

### 3. Plan

Summarize task ID, dependency status, files to touch, verification commands, and risks.

### 4. Execute

Follow AGENTS.md setup/testing/code style sections.

### 5. Close-out

Follow [references/close-out.md](references/close-out.md): verify, record node/edge changes, reconcile delta, report, and propose `완료` only if the user asked.
