---
name: adf-reconciliation
description: Audit Agentic Delivery Factory consistency across Notion tasks, Knowledge Nodes, Knowledge Edges, and this repo. Use when the user asks for 정합성 체크, graph audit, node consistency, edge validation, or when verifying ADF project health.
---

# ADF Reconciliation

Run this to detect drift between the ADF Notion SSOT and repository implementation.

## Scope

Default scope is the full ADF project:

- Task DB if available
- Knowledge Nodes
- Knowledge Edges
- Document Type Catalog
- This repo at current HEAD

If Task DB is not created yet, mark task-related checks as `N/A` and include `Create ADF Task DB` as P1.

## Checks

### A. Node Schema

For each active/draft node:

- `키` exists and is unique.
- `타입`, `카테고리`, `범위`, `상태`, `요약` are filled.
- `카테고리` matches the catalog category for the selected `타입`, or mismatch is intentionally documented.
- `저장소 경로` exists when the node claims implementation in repo.

### B. Edge Graph

Edge graph checks are P1 by default. Reconciliation is incomplete without them.

For each active edge:

- `출발 노드` and `대상 노드` are present and point to existing nodes.
- `관계 종류` is meaningful and not a placeholder.
- No duplicate edge for the same `출발 노드` / `대상 노드` / kind.
- Deprecated edges are not referenced as active dependencies.

For active/draft nodes with important dependencies:

- Dependencies expressed only in prose, with no matching edge, are drift.
- Nodes with `저장소 경로` should have an edge or reconciliation note explaining repo validation.
- Bootstrap-related nodes should connect to bootstrap spec / operating-system nodes through edges, not prose alone.

For tasks linked to graph work:

- Edge tasks must link at least one `관련 엣지`.
- Node tasks that create or change dependencies should also create/update edges via `adf-edge-workflow`.

### C. Task Flow

For each task (when DB exists):

- `작업 ID` follows `ADF-{track}-{number}-{kind}`.
- Implementation/documentation tasks link at least one node.
- Edge tasks link at least one edge.
- `완료` tasks have durable output in node, edge, repo path, or GTM artifact.
- Blocked tasks have `선행 작업` or a clear blocker note.

### D. Repo Alignment

- Root package/readme/AGENTS names match `agentic-delivery-factory`.
- Internal skills exist: task, node, edge, reconciliation.
- Shipped skill router exists under `skills/agentic-delivery-factory/SKILL.md`.
- `AGENTS.md` routes instance bootstrap to the shipped skill, not to internal `.cursor/skills/`.
- No internal skill claims to execute instance bootstrap end-to-end.
- Edge graph P1 checks (prose-only dependencies, bootstrap edges) live in Section B; apply them whenever repo alignment is audited.
- No active docs still instruct agents to use the legacy repo slug as the current repo name.

## Severity

- P0: Active SSOT points to missing/false implementation or critical graph edge is wrong.
- P1: Missing Task DB, missing required node fields, duplicate keys, broken active edge.
- P2: Category mismatch, missing repo path, stale README/package metadata.
- P3: Naming/style cleanup.

## Report Format

Create a Notion node or task note if write tools are available. Otherwise report in chat:

```markdown
## ADF Reconciliation — YYYY-MM-DD
Scope: [nodes/edges/tasks/repo]
Repo SHA: [sha]
Counts: P0=0, P1=0, P2=0, P3=0

### Findings
- [Severity] [Area] Finding → suggested fix

### Suggested Task Moves
- [Task ID] → status/action
```

Do not silently fix high-impact Notion changes during reconciliation. Propose them, then apply after confirmation unless the user requested direct repair.
