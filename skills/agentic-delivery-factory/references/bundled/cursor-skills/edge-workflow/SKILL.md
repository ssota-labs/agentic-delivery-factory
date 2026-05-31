---
name: {{PROJECT_SLUG}}-edge-workflow
description: Create or update {{PROJECT_NAME}} Knowledge Edges between nodes. Use when linking project nodes, documenting dependencies, or adding graph relationships.
---

# {{PROJECT_NAME}} Edge Workflow

Edges DB: [{{EDGES_DB_URL}}]({{EDGES_DB_URL}})  
Nodes DB: [{{NODES_DB_URL}}]({{NODES_DB_URL}})

## Workflow

1. Fetch/search both endpoint nodes.
2. Check for an existing edge with the same `출발 노드` / `대상 노드` / kind.
3. Create or update the edge with `상태 = Active` unless speculative.
4. Use `Deprecated` instead of deleting historical relationships.
5. Link relevant task rows when Tasks DB exists.

## Relationship Kinds

Preferred vocabulary: `defines`, `depends_on`, `implements`, `validates`, `supersedes`, `references`, `blocks`, `produces`.

## Required Properties

`관계`, `출발 노드`, `대상 노드`, `관계 종류`, `상태`.
