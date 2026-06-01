---
name: {{PROJECT_SLUG}}-documentation-workflow
description: Write or update {{PROJECT_NAME}} Knowledge Node documents. Use after AGENTS.md routes work to node/documentation authoring, especially for PRD, architecture, policy, runbook, spec, or decision-record nodes.
---

# {{PROJECT_NAME}} Documentation Workflow

Primary deliverable is a **Knowledge Node page** in Notion, not a loose markdown file.

## Databases

- Nodes: [{{NODES_DB_URL}}]({{NODES_DB_URL}})
- Catalog: [{{CATALOG_DB_URL}}]({{CATALOG_DB_URL}})
- Tasks: [{{TASKS_DB_URL}}]({{TASKS_DB_URL}})

## Path selection (v0.4)

Read stage map + handoff policy before drafting. Co-authoring is a **branch of this skill**, not a separate AGENTS router entry.

| Use co-authoring branch | Use template-fill path |
|---|---|
| User intent exploratory or multi-stakeholder | Catalog template + inputs available |
| Scope spans product/design/technical tradeoffs | User asked to execute ("노드 작성해", "템플릿대로") |
| Document drives downstream gate nodes (PRD, plan) | No open DEC/Q blocking structure |
| User asks to co-write section-by-section | Single-pass SSOT write is appropriate |

When co-authoring branch applies, read `{SKILLS_INSTALL_DIR}/{{PROJECT_SLUG}}-doc-coauthoring/SKILL.md` and follow it. Do **not** add `doc-coauthoring` as a top-level AGENTS router row.

Policy SSOT: `{PROJECT_SLUG}.delivery-workflow.doc-coauthoring` or ADF seed `adf.delivery-workflow.doc-coauthoring`.

## Workflow

1. Load the task row and linked nodes.
2. Select path per table above.
3. Search for an existing node before creating a new one.
4. Pick `타입` from Catalog, fetch that catalog page, and read its body. Catalog page is the only SSOT for the writing template.
5. If the catalog page lacks `## … 작성 템플릿`, write the Korean template into the catalog page first, then draft the node.
6. Draft/update the node body following the catalog template (or co-authoring branch steps).
7. Link task via `관련 노드`.
8. Create/update important graph relationships through `{{PROJECT_SLUG}}-edge-workflow`.
9. Apply the completion rule for the current run mode: interactive runs propose `완료` only if the user asked; scheduler runs may set `완료` when `.adf/config.json` has `automation.autoCompleteOnScheduler = true` and documentation close-out gates pass.
10. Do **not** set planning/design nodes `Active` or unblock `구현` without explicit human handoff when scope is still forming.

## Document Type Guidance

- Project/feature intent -> Project Brief / PRD
- Architecture -> Architecture Overview
- Current behavior -> Functional Spec
- How-to operation -> Runbook
- Recurring rule -> Policy/Standard
- One-way decision -> Decision Record
- Implementation breakdown -> Implementation Plan

## Anti-patterns

- Writing durable project knowledge only in chat.
- Creating a node without reading the catalog page template first.
- Storing catalog templates in the repo or as Knowledge Node template rows.
- Adding prose references instead of graph edges for important relationships.
- Auto-filling an entire PRD in one shot when co-authoring branch was selected.
