---
name: {{PROJECT_SLUG}}-reconciliation
description: Run SSOT reconciliation for {{PROJECT_NAME}} across Notion tasks, Knowledge Nodes, Knowledge Edges, and repo main. Use for 정합성 체크, graph audit, drift audit, or periodic consistency checks.
---

# {{PROJECT_NAME}} Reconciliation

Default scope is the entire project unless the user narrows it.

## Databases

- Tasks: [{{TASKS_DB_URL}}]({{TASKS_DB_URL}})
- Nodes: [{{NODES_DB_URL}}]({{NODES_DB_URL}})
- Edges: [{{EDGES_DB_URL}}]({{EDGES_DB_URL}})

## Progressive References

- [references/checklist.md](references/checklist.md)
- [references/report-template.md](references/report-template.md)

## Workflow

1. Load all active/draft nodes and active edges.
2. Load all tasks unless scope is narrowed.
3. Check node required fields, duplicate keys, edge endpoints, duplicate edges, prose-only dependencies, bootstrap edge coverage, task links, and repo path validity.
4. Append results to the current weekly Reconciliation Run Log Knowledge Node if Notion write tools are available.
5. Report P0/P1 counts and suggested fixes. Do not auto-complete tasks unless asked.

## Scheduled Sweep Mode

For daily scheduled sweeps, prefer the validation-state properties instead of re-reading the whole graph:

- Start with rows where `정합성 확인됨 != true`.
- Include rows where `정합성 상태` is empty, `미확인`, `주의`, or `깨짐`.
- Include completed tasks with missing durable output.
- Include nodes with `저장소 경로` when repo HEAD changed since the last sweep.
- Record each run in a weekly run log node keyed like `{project}.reconciliation.run-log.YYYY-wNN`.
- On pass, set `정합성 확인됨 = true`, `정합성 상태 = 정상`, and update `마지막 정합성 확인일`.
- On drift, leave `정합성 확인됨 = false`, set `정합성 상태 = 주의` or `깨짐`, and write `정합성 메모`.

## P0 Policy

If an active edge points to missing nodes, a completed task has no durable output, or repo implementation contradicts an Active node contract, recommend pausing dependent implementation until fixed.
