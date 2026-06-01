# Implementation gate

Run before editing code or docs for a `구현` or `검증` task.

When `.adf/config.json` has `workflowVersion >= 1.3`, also run the **design gate** section below.

When `bootstrapVersion >= 0.5` and `deliveryProfile.gateMode != legacy`, also run the **dynamic gate** section below.

## Checklist

1. **Intake decided** — confirm whether this work needs a node, task, and edges before proceeding.
2. **Task located** — read `선행 작업`, `후행 작업`, `상태`, `관련 노드`, `관련 엣지`, and linked `목표`.
3. **Task state** — set `진행중` and `진행일` when starting; use `보류` for blockers.
4. **Node contracts loaded** — linked nodes are not empty and have `상태` Draft/Active, `키`, `타입`, `카테고리`, and `요약`.
5. **Edge dependencies loaded** — active linked edges have valid `출발 노드`, `대상 노드`, and `관계 종류`.
6. **Repo context loaded** — read `AGENTS.md`, `.adf/config.json`, relevant `저장소 경로`, and implementation files.
7. **Override** — only proceed past gaps if user explicitly accepts risk.

## Design gate (workflowVersion >= 1.3)

Before `구현` or scheduler `검증` pickup:

1. Load stage map SSOT node `{PROJECT_SLUG}.delivery-workflow.catalog-stage-map` or repo reference `references/schemas/delivery-workflow-stage-map.md`.
2. Inspect task `관련 노드` and determine applicable gate row (any feature, UI, backend/API, lean backend-only, verification class).
3. Every required gate node MUST be `Active` before implementation starts.
4. In **scheduler mode**: if any required node is `Draft` or missing → set task `보류` with missing list; do not implement; do not promote node `상태`.
5. In **interactive mode**: do not treat Draft planning nodes as sufficient for multi-step feature implementation; human handoff (`Active`) is required per intent-handoff-gate policy.

### Minimum gate rows

| Class | Required | Blocks |
|---|---|---|
| Any feature | PRD `Active` | `구현` pickup |
| Backend/API | PRD + Tech Spec + (Functional Spec or API Spec) `Active` | API/data impl |
| Lean backend-only | PRD `Active` (+ S5 when API/data) | backend-only impl |
| First UI surface | PRD + IA baseline + UI foundation baseline `Active` | first UI impl |

On verification tasks, require evidence appropriate to the verification class (Test Plan, Test Run Report, etc.) per stage map §7.

## Dynamic gate (bootstrapVersion >= 0.5, gateMode = full)

Before first product `구현` or when instance gate policy defines additional rows:

1. Load instance SSOT node `{PROJECT_SLUG}.delivery-workflow.implementation-gate-policy` (Draft/Active).
2. If gate policy is missing and `gateMode=full` → block with composer/bootstrap recovery action.
3. Instance **Implementation Gate Policy** MUST be `Active` before **first product** `구현` pickup (blocks `{TASK_PREFIX}-PLAT-003-IMPL` class scaffold tasks only when they are product implementation — bootstrap scaffold may proceed per bootstrap plan).
4. Required nodes = **stricter union** of instance gate policy tables + Stage Map row for the task's surface/layer/trigger.
5. In **scheduler mode**: if gate policy is `Draft` or any required gate node is not `Active` → set task `보류` with missing list; do not implement.
6. Composer assumptions with `conflict:` prefix → block Active promotion until human resolves.

Repo references when Notion node body is empty: `references/schemas/delivery-profile-matrix.md`, bundled gate policy trace on the node.

Legacy path (`deliveryProfile.gateMode=legacy` or `bootstrapVersion < 0.5`): design gate + Stage Map static rows only.

## Blocker template

```markdown
Cannot start implementation yet.

Selected task: [task ID]
Blocked by:
- [missing task row or goal link]
- [missing linked node / empty node contract]
- [missing or invalid edge dependency]
- [Notion 선행 작업 relation or incomplete predecessor]
- [design gate: required node Draft/missing — list types/keys]
- [dynamic gate: Implementation Gate Policy Draft/missing or conflict unresolved]
- [repo vs node contract mismatch]

Next recommended action:
- [node/edge/task to create or fix]
- [human handoff to Active for listed gate nodes]
```
