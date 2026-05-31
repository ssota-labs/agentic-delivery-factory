# Notion relation setup

Run after Goals, Catalog, Nodes, Edges, and Tasks databases exist and you have data source IDs.

Goals must be a **project-local** database created under the instance project page. Do not link Tasks to a workspace-wide goals tracker.

## Nodes relations / rollups

On Nodes (`NODES_DS_ID`):

```sql
ALTER TABLE ADD COLUMN "타입" RELATION('CATALOG_DS_ID', DUAL '노드' 'nodes');
```

Keep native select `카테고리` for board grouping. Optionally add rollups for display only:

```sql
ALTER TABLE ADD COLUMN "문서 성격" ROLLUP('타입', '문서 성격', 'show_unique');
ALTER TABLE ADD COLUMN "관리 방식" ROLLUP('타입', '관리 방식', 'show_unique');
```

## Edges relations

On Edges (`EDGES_DS_ID`):

```sql
ALTER TABLE ADD COLUMN "출발 노드" RELATION('NODES_DS_ID');
ALTER TABLE ADD COLUMN "대상 노드" RELATION('NODES_DS_ID');
```

## Tasks relations

On Tasks (`TASKS_DS_ID`):

```sql
ALTER TABLE ADD COLUMN "목표" RELATION('GOALS_DS_ID', DUAL '작업' 'tasks');
ALTER TABLE ADD COLUMN "관련 노드" RELATION('NODES_DS_ID');
ALTER TABLE ADD COLUMN "관련 엣지" RELATION('EDGES_DS_ID');
ALTER TABLE ADD COLUMN "선행 작업" RELATION('TASKS_DS_ID', DUAL '후행 작업' 'blocking');
ALTER TABLE ADD COLUMN "후행 작업" RELATION('TASKS_DS_ID', DUAL '선행 작업' 'blocked_by');
```

Replace placeholders with actual data source IDs. Fetch schemas afterward and verify all relation properties exist.
