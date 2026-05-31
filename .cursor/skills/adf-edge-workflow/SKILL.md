---
name: adf-edge-workflow
description: Create or update Agentic Delivery Factory Knowledge Edges between nodes. Use when linking ADF nodes, defining dependencies, adding graph relationships, or explaining how one node defines, implements, validates, supersedes, or references another.
---

# ADF Edge Workflow

Edges make the factory graph navigable. Create an edge whenever relationship knowledge would otherwise be trapped in prose.

## Databases

- Nodes: https://www.notion.so/04e803dbef5243e39ed02ab370d2290b
- Edges: https://www.notion.so/a2a643eaa6e04981af72bad558115b2c

## Workflow

1. Fetch/search both endpoint nodes. Do not create an edge to an ambiguous node.
2. Check if the same `출발 노드` / `대상 노드` / kind already exists.
3. Create or update the edge with `상태 = Active` unless it is speculative (`Draft`).
4. If the relation is no longer true, prefer `Deprecated` over deletion.
5. Link the edge to the relevant task through `관련 엣지` when Tasks DB exists.

## Edge Properties

| Property | Rule |
|---|---|
| `관계` | Human-readable label, e.g. `Task DB Schema -> Task Workflow` |
| `출발 노드` | Source node relation |
| `대상 노드` | Target node relation |
| `관계 종류` | Relationship kind |
| `상태` | Draft / Active / Deprecated / Archived |
| `메모` | Optional one-line rationale if available |

## Relationship Kinds

Use the closest existing option. Preferred vocabulary:

- `defines`: source defines target
- `depends_on`: source requires target
- `implements`: source implements target
- `validates`: source validates target
- `supersedes`: source replaces target
- `references`: source cites target
- `blocks`: source blocks target
- `produces`: source produces target

If the Notion options differ, use the existing closest option and record the intended meaning in `메모`.

## Common ADF Edges

- Project overview `defines` factory architecture.
- Factory architecture `defines` task workflow, node workflow, edge workflow.
- Task workflow `produces` node and edge changes.
- Reconciliation `validates` node/task/edge consistency.
- Bootstrap spec `implements` scaffold templates and generated instance setup.
