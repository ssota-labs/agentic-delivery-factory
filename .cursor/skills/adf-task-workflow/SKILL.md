---
name: adf-task-workflow
description: Manage Agentic Delivery Factory Notion tasks. Use when the user asks to create, update, pick up, block, or plan ADF tasks; mentions ADF-P* task IDs; or asks to connect work to the ADF Task DB, Knowledge Nodes, or Goals.
---

# ADF Task Workflow

Use this for ADF project task operations. Notion is the source of truth; repository files are implementation artifacts.

This skill operates the ADF meta factory itself. Do not use it to bootstrap a new instance project. Instance bootstrap requests route to `skills/agentic-delivery-factory/SKILL.md`.

## Databases

- Project: https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511
- Goals (project-local): https://www.notion.so/e4cbfacc00ee49238b04fb99431bf86b
- Nodes: https://www.notion.so/04e803dbef5243e39ed02ab370d2290b
- Edges: https://www.notion.so/a2a643eaa6e04981af72bad558115b2c
- Tasks: https://www.notion.so/6121db0090bf42df96f790bb27b202f4

## Workflow

1. Load `.adf/config.json` and the ADF project page.
2. Fetch the Tasks DB schema if creating or updating task rows.
3. For user-named task IDs, fetch the row. Otherwise query `상태 in (진행중, 대기)` sorted by `우선순위` / `작업 ID` and confirm the selected task.
4. Set `상태 = 진행중` only when starting work. Set `진행일` as a datetime (`date:진행일:is_datetime=1`, ISO-8601) at pickup. Use `보류` for blockers. Do not set `완료` unless the user explicitly asks.
5. Link every non-trivial task to at least one `목표`. If the work does not serve an existing goal, create or request a goal before adding task sprawl.
6. Link durable output through `관련 노드` and `관련 엣지` when the task creates or changes graph artifacts.
7. Report: task ID, status change, linked goal, linked nodes/edges, next unblocked task.

## Task ID Convention

Use `ADF-{track}-{number}-{kind}`.

Examples:

- `ADF-PLAT-001-TASKDB`
- `ADF-PLAT-002-NODE`
- `ADF-PLAT-003-EDGE`
- `ADF-GTM-001-CONTENT`

Tracks: `PLAT`, `GTM`, `OPS`. Kinds: `TASKDB`, `NODE`, `EDGE`, `SKILL`, `DOC`, `IMPL`, `VERF`, `CONTENT`.

## Work Types

- `공장 설계`: factory architecture, policies, scaffold rules
- `스킬 작성`: shipped or internal ADF skill changes
- `노드 문서 작성`: Knowledge Node creation/update
- `엣지 생성`: Knowledge Edge creation/update
- `정합성 체크`: graph/task/repo reconciliation
- `구현`: repo implementation
- `검증`: test/eval/review
- `GTM`: portfolio/content/landing/customer validation

## Required Task Properties

- `작업` title
- `작업 ID`
- `상태`
- `작업 유형`
- `트랙`
- `우선순위`
- `목표`
- `관련 노드`
- `관련 엣지`
- `선행 작업` / `후행 작업`

## Dates

- `진행일`: work start or active pickup time. Set when moving to `진행중` as a datetime (`date:진행일:is_datetime=1`, e.g. `2026-05-31T14:45:00.000Z`).
- `마감일`: target completion date. Usually date-only (`date:마감일:is_datetime=0`).
- Timeline views use `TIMELINE BY "진행일" TO "마감일"` so bars span from start to deadline.

## Safety

- Do not create duplicate tasks. Search by `작업 ID`, title keywords, and linked node first.
- Do not mark tasks complete unless the user asks.
- If a task changes factory behavior, ensure a Knowledge Node exists or create one via `adf-node-authoring`.
- Goals must always be quantitative. Every goal needs `기준값`, `현재값`, `목표값`, `단위`, `지표`, `KPI 영역`, and `측정 기준`. Do not create qualitative-only goals.
- Tasks are the work; goals are the numeric outcome the work serves. Update `현재값` when measurable progress happens.
