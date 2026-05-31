# Task responsibility unit policy

Policy SSOT: Knowledge Node `{{PROJECT_SLUG}}.task-policy.responsibility-unit` or seeded copy of ADF node `adf.task-policy.responsibility-unit`. **Version: 1.0**

Read `.adf/config.json` → `taskPolicyVersion`. When `taskPolicyVersion >= 1.0`, apply this reference on every task create/split/review.

## Single responsibility (MUST)

One task row = one of each:

| Dimension | Rule |
|---|---|
| Primary deliverable | One artifact type (design node, skill package, E2E report, …) |
| Primary `작업 유형` | One work type only |
| Close-out gate | One completion criterion |
| `작업 ID` suffix | Matches primary responsibility (`DOC`, `SKILL`, `IMPL`, `VERF`, …) |

Do **not** combine design/policy work, skill authoring, implementation, and verification in one task.

## Split triggers

Split into a task chain when the proposed scope includes any of:

- Multiple deliverable **types**
- Multiple **phases** owned by different workflow skills
- Multiple **leading KPIs**
- Mixed **human handoff** and **autonomous execution**
- Mixed **Meta** design and **Instance** proof

## Task chain wiring (MUST)

```text
{{TASK_PREFIX}}-010-DOC  →  {{TASK_PREFIX}}-011-SKILL  →  {{TASK_PREFIX}}-012-VERF
```

For each child task:

1. Set blocking `선행 작업` and mirror `후행 작업` on the predecessor.
2. Fill `종속성`: `상위 KPI: {parent goal} → {direct goal} | 선행: … | 후행: …`
3. Link `목표` to the **direct leading KPI only**.
4. Keep downstream tasks `대기` without `진행일` until predecessors are `완료`.
5. Cancel umbrella tasks; add split notice with child links.

## Split procedure

When intake detects split triggers, or the user says responsibilities do not align:

1. Propose 2–4 tasks with distinct deliverables, kinds, and goals.
2. Wire dependencies before setting any child to `진행중`.
3. Cancel the umbrella task.
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

## Anti-patterns

- Umbrella task mixing design + skill + E2E
- One task linked to two peer leading KPIs when a chain is clearer
- `진행일` on blocked downstream tasks
