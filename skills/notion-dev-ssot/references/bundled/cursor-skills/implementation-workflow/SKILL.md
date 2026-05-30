---
name: {{PROJECT_SLUG}}-implementation-workflow
description: Implement or verify {{PROJECT_NAME}} code from Notion tasks (작업 유형 구현/검증). Use after AGENTS.md routes work to implementation. Follow AGENTS.md for coding conventions; this skill covers gate, plan, close-out, and small Spec/Policy patches.
---

# {{PROJECT_NAME}} Implementation Workflow

**Coding conventions** live in **`AGENTS.md`** — they stay loaded for long sessions. This skill covers **procedure** only.

## Prerequisites

- AGENTS.md Development router completed (Notion MCP, task row loaded).
- Task `작업 유형` is `구현` or `검증` (or user explicitly requested implementation).

## Progressive references

- [references/implementation-gate.md](references/implementation-gate.md) — pre-code checklist
- [references/close-out.md](references/close-out.md) — verify, record, reconcile delta, report

## Workflow

### 1. Gate (before any edit)

Run [references/implementation-gate.md](references/implementation-gate.md). If blocked, stop and use the blocker template there.

### 2. Read context

- Linked PRD and D3 from `관련 문서`
- `README.md`, relevant code on `main`
- Predecessor milestone code per `종속성` / Blueprint

Do not plan from Notion alone.

### 3. Plan

Summarize: task ID, dependency status, files to touch, verification commands, risks.

### 4. Execute

Follow **AGENTS.md** sections: Setup, Development Workflow, Testing, Code Style.

Long session: re-read AGENTS implementation conventions if the thread is very long.

### 5. Close-out

Follow [references/close-out.md](references/close-out.md):

- **Verify** — commands from AGENTS.md Testing section
- **Record** — Notion Spec/ADR/릴리즈 노트 as needed; link `관련 문서`
- **Small Spec/Policy** — update topic Spec (or Policy) inline when the contract change is limited to this PR
- **Reconcile delta** — task row vs `main`; for `검증` tasks, recommend full [{{PROJECT_SLUG}}-reconciliation](../{{PROJECT_SLUG}}-reconciliation/SKILL.md) if not run recently
- **Report** — user summary; propose `완료` only if user asked
