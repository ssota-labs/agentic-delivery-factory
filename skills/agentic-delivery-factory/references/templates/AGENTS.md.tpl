# AGENTS.md

Instructions for AI agents working in **{{GITHUB_REPO}}**.

## Project Overview

**{{PROJECT_NAME}}** — {{PROJECT_OVERVIEW}}

Machine-readable ADF config: [`.adf/config.json`](.adf/config.json).

## Delivery SSOT: Notion Knowledge Graph

Notion is the source of truth for goals, planning, decisions, node documents, graph relationships, and task state. The repository holds implementation artifacts.

| Database | URL |
|---|---|
| Project | {{PROJECT_URL}} |
| Goals | {{GOALS_DB_URL}} |
| Catalog | {{CATALOG_DB_URL}} |
| Nodes | {{NODES_DB_URL}} |
| Edges | {{EDGES_DB_URL}} |
| Tasks | {{TASKS_DB_URL}} |

## Agent Router

For any substantive request, start by loading Notion context.

1. Confirm Notion MCP/tools are available. If not, do repo-only work and report exact Notion updates still needed.
2. Run the request intake gate below before creating files or Notion rows.
3. Load the task row if the user named `{{TASK_PREFIX}}-*`; otherwise identify or create the task needed for the work.
4. Load linked goals, nodes, and edges before writing code or docs.

## Request Intake Gate

Before starting non-trivial work, decide explicitly:

| Question | If yes | If no |
|---|---|---|
| Does this need a Knowledge Node? | Create or update via node authoring before or during the work | Record why chat-only is enough |
| Does this need a Task row? | Create or pick up a task, link `목표`, set `진행중` at start | Keep the work conversational only when truly trivial |
| Does this need graph edges? | Create/update edges for dependencies, definitions, or validations | Note prose-only risk in task or node memo |

Interactive close-out rules:

1. Record durable output in nodes/edges/repo paths, not only chat.
2. Link the task through `관련 노드` and `관련 엣지` when graph artifacts changed.
3. Set `정합성 확인됨 = false` and `정합성 상태 = 미확인` on materially changed rows unless reconciliation ran in the same operation.
4. Propose `완료` only when the user explicitly asks. Scheduler automation uses the separate scheduler close-out rule below.
5. Report task ID, node/edge evidence, repo paths, and next step.

## Scheduler Loop

When running from the Dev Task Loop Cursor Automation:

1. Treat the run mode as `scheduler`.
2. Load `.adf/config.json`, especially `automation.integrationBranch`, `automation.releaseBranch`, and `automation.autoCompleteOnScheduler`.
3. Run the Notion gate and de-dupe/conflict-first checks before selecting work.
4. Resume dependency-ready `진행중` task/PR work before starting a new task.
5. Pick only a `대기` task whose `선행 작업` are complete and whose required node/edge/repo inputs exist.
6. If no task is dependency-ready, no-op for this tick. Do not bypass dependencies or start speculative work.
7. Route selected work through the same skills listed below.
8. Never auto-merge or push to the release branch.

### Scheduler Close-Out

Interactive runs and scheduler runs have different completion rules:

| Run mode | Completion rule |
|---|---|
| Interactive chat | Propose `완료` only when the user explicitly asks. |
| Scheduler automation | If `automation.autoCompleteOnScheduler = true` and all close-out gates pass, set task `상태 = 완료` directly. |

If scheduler close-out gates fail, set `상태 = 보류` with a blocker note instead of asking the user what to do next. The next automation tick should resume or no-op.

| User intent | Read skill |
|---|---|
| Task pickup/status/plan | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-task-workflow/SKILL.md` |
| Node document create/update | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-node-authoring/SKILL.md` |
| Edge creation/graph relation | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-edge-workflow/SKILL.md` |
| Implementation/verification | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-implementation-workflow/SKILL.md` |
| Reconciliation/drift audit | `{{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-reconciliation/SKILL.md` |

## Node Rules

- Every durable concept or contract should have a Knowledge Node.
- Use stable `키` values: `{{PROJECT_SLUG}}.<area>.<topic>`.
- Set `타입`, `카테고리`, `범위`, `상태`, and `요약`.
- Create edges for important dependencies and definitions.
- Use native select `카테고리` for board grouping.

## Task Rules

- `상태`: `대기` / `진행중` / `보류` / `완료` / `취소`.
- Every non-trivial task should link to at least one `목표`.
- Interactive runs should not set `완료` unless the user explicitly asks.
- Scheduler runs may set `완료` when `automation.autoCompleteOnScheduler = true` and close-out gates pass.
- Implementation tasks should link relevant `관련 노드`; graph tasks should link `관련 엣지`.

## Reconciliation State

Nodes, Edges, and Tasks use:

- `정합성 확인됨`
- `정합성 상태`: `미확인`, `정상`, `주의`, `깨짐`
- `마지막 정합성 확인일`
- `정합성 메모`

When materially editing a Node, Edge, or Task, set `정합성 확인됨 = false` and `정합성 상태 = 미확인` unless reconciliation ran in the same operation.

## Operating Loop

1. Classify intent through the router.
2. Run the request intake gate.
3. Load Goals, Tasks, Nodes, and Edges from Notion.
4. Read the catalog page template before writing a node.
5. Execute the smallest repo or Notion change needed.
6. Create or update edges for meaningful dependencies.
7. Run reconciliation when graph, repo, or bootstrap boundaries change.
8. Close out with task status, node/edge evidence, repo paths, and next step.

{{FULL_PROFILE_SECTIONS}}
