# Task responsibility unit policy

Policy SSOT: Notion node `adf.task-policy.responsibility-unit` (Task Responsibility Unit Policy). **Version: 1.0**

Use this reference when creating, splitting, or reviewing Tasks DB rows.

## Single responsibility (MUST)

One task row = one of each:

| Dimension | Rule |
|---|---|
| Primary deliverable | One artifact type (design node, skill package, E2E report, …) |
| Primary `작업 유형` | One work type only |
| Close-out gate | One completion criterion |
| `작업 ID` suffix | Matches primary responsibility (`DOC`, `SKILL`, `IMPL`, `VERF`, …) |

Do **not** combine `공장 설계` + `스킬 작성` + `검증` in one task.

## Split triggers

Split into a task chain when the proposed scope includes any of:

- Multiple deliverable **types** (Notion design + repo skill + install log)
- Multiple **phases** owned by different skills (design → skill → E2E)
- Multiple **leading KPIs** (e.g. SSOT completeness vs bootstrap verification runs)
- Mixed **human handoff** and **autonomous execution**
- Mixed **Meta** design and **Instance** proof in one row

## Task chain wiring (MUST)

```text
{PREFIX}-010-DOC  →  {PREFIX}-011-SKILL  →  {PREFIX}-012-VERF
```

For each child task:

1. Set blocking `선행 작업` and mirror `후행 작업` on the predecessor.
2. Fill `종속성`: `상위 KPI: {parent} → {direct} | 선행: … | 후행: …`
3. Link `목표` to the **direct leading KPI only** (parent outcome via Goal `상위 목표`).
4. Keep downstream tasks `대기` without `진행일` until predecessors are `완료`.
5. Cancel umbrella tasks; do not leave active parent + split children.

## Split procedure

When intake detects split triggers, or the user says responsibilities do not align:

1. Propose 2–4 tasks with distinct deliverables, kinds, and goals.
2. Wire dependencies before setting any child to `진행중`.
3. Cancel the umbrella task with a split notice linking children.
4. Pick up only the first dependency-ready task.

## Kind suffix map

| Suffix | `작업 유형` | Deliverable |
|---|---|---|
| `DOC` | `공장 설계` | Policy, stage map, architecture design |
| `SKILL` | `스킬 작성` | Skill package change |
| `NODE` | `노드 문서 작성` | Knowledge Node page |
| `EDGE` | `엣지 생성` | Knowledge Edge rows |
| `IMPL` | `구현` | Repo implementation |
| `VERF` | `검증` | Test, dry-run, E2E proof |

## Example (good)

- `ADF-PLAT-010-DOC` — stage map design → GOAL-009
- `ADF-PLAT-011-SKILL` — handoff gate + co-authoring skill → GOAL-009, 선행 010
- `ADF-PLAT-012-VERF` — skill.sh E2E → GOAL-008, 선행 010+011

## Anti-patterns

- Umbrella task: "design + skill + E2E" in one row
- One task linked to two peer leading KPIs when a chain is clearer
- `진행일` on blocked downstream tasks
- Cancelled umbrella still linked to active Goals
