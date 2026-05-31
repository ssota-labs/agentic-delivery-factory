---
name: {{PROJECT_SLUG}}-node-authoring
description: Create or update {{PROJECT_NAME}} Knowledge Nodes. Use when writing node documents, adding SSOT nodes, updating node properties, or turning discussion into durable project knowledge.
---

# {{PROJECT_NAME}} Node Authoring

Nodes DB: [{{NODES_DB_URL}}]({{NODES_DB_URL}})  
Catalog: [{{CATALOG_DB_URL}}]({{CATALOG_DB_URL}})

## Workflow

1. Search existing nodes by title, `키`, and related terms.
2. Pick `타입` from the catalog, fetch that catalog page, and read its body. The catalog page is the only SSOT for how to write that document type.
3. Set `카테고리` native select for board grouping.
4. Set `범위`, `상태`, `요약`, and `저장소 경로` if implemented.
5. Write the page body using the template below.
6. Create edges for important relationships through `{{PROJECT_SLUG}}-edge-workflow`.

## Catalog Page Templates (Notion SSOT)

Templates live only in Document Type Catalog page bodies. Do not use repo files or Knowledge Node template rows as SSOT.

If the catalog page lacks `## … 작성 템플릿`, write the Korean template into the catalog page first, then create the node from it.

## Required Properties

`노드`, `키`, `타입`, `카테고리`, `범위`, `상태`, `요약`.
