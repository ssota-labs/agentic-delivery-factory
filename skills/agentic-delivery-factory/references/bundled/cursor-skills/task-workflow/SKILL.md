---
name: {{PROJECT_SLUG}}-task-workflow
description: Manage {{PROJECT_NAME}} Notion tasks. Use when creating, updating, picking up, blocking, or closing project tasks, or when the user mentions {{TASK_PREFIX}}-* task IDs.
---

# {{PROJECT_NAME}} Task Workflow

Tasks DB: [{{TASKS_DB_URL}}]({{TASKS_DB_URL}})

## Workflow

1. Load `.adf/config.json`.
2. Decide whether the incoming request needs a task row. Create one for non-trivial work unless the user explicitly wants chat-only handling.
3. Fetch the named task row or choose the next `대기` / `진행중` task after confirming with the user.
4. Load linked `관련 노드`, `관련 엣지`, and `목표`.
5. Set `상태 = 진행중` only when starting work. Set `진행일` as a datetime (`date:진행일:is_datetime=1`, ISO-8601) at pickup.
6. Use `보류` for blockers with `선행 작업` or blocker note.
7. Link durable output through `관련 노드` and `관련 엣지` when the task creates or changes graph artifacts.
8. When materially changing a task or its linked output, set `정합성 확인됨 = false` and `정합성 상태 = 미확인` unless reconciliation ran in the same operation.
9. Interactive runs should not set `완료` unless the user explicitly asks. Scheduler runs may set `완료` only when `.adf/config.json` has `automation.autoCompleteOnScheduler = true` and the routed workflow's close-out gates pass.
10. Report task ID, status, linked goal/nodes/edges, and next step.

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
