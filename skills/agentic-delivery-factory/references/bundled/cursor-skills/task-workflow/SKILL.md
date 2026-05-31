---
name: {{PROJECT_SLUG}}-task-workflow
description: Manage {{PROJECT_NAME}} Notion tasks. Use when creating, updating, picking up, blocking, or closing project tasks, or when the user mentions {{TASK_PREFIX}}-* task IDs.
---

# {{PROJECT_NAME}} Task Workflow

Tasks DB: [{{TASKS_DB_URL}}]({{TASKS_DB_URL}})

## Responsibility unit policy

Before creating or splitting tasks, read [references/responsibility-unit.md](references/responsibility-unit.md). Apply when `.adf/config.json` has `taskPolicyVersion >= 1.0`.

- One task = one primary deliverable, one `작업 유형`, one close-out gate.
- Split design / skill / implementation / verification into a task chain.
- Link `목표` to the direct leading KPI only; use `종속성` for parent KPI and `선행` / `후행` chain.
- Cancel umbrella tasks when responsibilities do not align.

## Workflow

1. Load `.adf/config.json`.
2. Run the responsibility-unit split check when creating or merging task scope.
3. Decide whether the incoming request needs a task row. Create one for non-trivial work unless the user explicitly wants chat-only handling.
4. Fetch the named task row or choose the next dependency-ready `대기` / `진행중` task after confirming with the user.
5. Load linked `관련 노드`, `관련 엣지`, `목표`, and `선행 작업`.
6. Set `상태 = 진행중` only when starting work and blocking predecessors are `완료`. Set `진행일` as a datetime (`date:진행일:is_datetime=1`, ISO-8601) at pickup.
7. Use `보류` for blockers with `선행 작업` or blocker note.
8. Link durable output through `관련 노드` and `관련 엣지` when the task creates or changes graph artifacts.
9. When materially changing a task or its linked output, set `정합성 확인됨 = false` and `정합성 상태 = 미확인` unless reconciliation ran in the same operation.
10. Interactive runs should not set `완료` unless the user explicitly asks. Scheduler runs may set `완료` only when `.adf/config.json` has `automation.autoCompleteOnScheduler = true` and the routed workflow's close-out gates pass.
11. Report task ID, status, linked goal/nodes/edges, dependency chain, and next step.

## Task Rules

- Task IDs use `{{TASK_PREFIX}}-{track}-{number}-{kind}`.
- Every non-trivial task should link to at least one `목표`.
- Implementation tasks should link relevant Knowledge Nodes.
- Graph tasks should link relevant Knowledge Edges.
- Durable outcomes must be recorded in nodes/edges, not only chat.
- `진행일` is the timeline start (datetime). `마감일` is the deadline (date-only). Default timeline views: `TIMELINE BY "진행일" TO "마감일"`.

## Required Task Properties

- `작업`, `작업 ID`, `상태`, `작업 유형`, `트랙`, `우선순위`
- `목표`, `관련 노드`, `관련 엣지`
- `선행 작업` / `후행 작업`
- `정합성 확인됨`, `정합성 상태`, `마지막 정합성 확인일`, `정합성 메모`
