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

## Workflow

1. Load the task row and linked nodes.
2. Search for an existing node before creating a new one.
3. Pick `타입` from Catalog, fetch that catalog page, and read its body. Catalog page is the only SSOT for the writing template.
4. If the catalog page lacks `## … 작성 템플릿`, write the Korean template into the catalog page first, then draft the node.
5. Draft/update the node body following the catalog template.
6. Link task via `관련 노드`.
7. Create/update important graph relationships through `{{PROJECT_SLUG}}-edge-workflow`.
8. Apply the completion rule for the current run mode: interactive runs propose `완료` only if the user asked; scheduler runs may set `완료` when `.adf/config.json` has `automation.autoCompleteOnScheduler = true` and documentation close-out gates pass.

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
