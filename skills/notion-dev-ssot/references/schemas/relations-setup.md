# Notion relation setup (2-step)

Relations cannot all be declared in the initial `notion-create-database` call when they reference other data sources. Run this **after** both databases exist and you have both `data_source_id` values from `notion-fetch`.

Record IDs during init:

| Key | Value |
|---|---|
| `TASKS_DS_ID` | Tasks database data_source_id |
| `DOCS_DS_ID` | Docs database data_source_id |

## Step 1 — Tasks database: cross + self relations

Use `notion-update-data-source` on **Tasks** (`TASKS_DS_ID`):

```sql
ALTER TABLE ADD COLUMN "관련 문서" RELATION('DOCS_DS_ID', DUAL '관련 태스크' 'related_tasks');
ALTER TABLE ADD COLUMN "Blocked by" RELATION('TASKS_DS_ID', DUAL 'Blocking' 'blocking');
ALTER TABLE ADD COLUMN "Blocking" RELATION('TASKS_DS_ID', DUAL 'Blocked by' 'blocked_by');
```

Replace `DOCS_DS_ID` and `TASKS_DS_ID` with actual UUIDs (with or without dashes).

## Step 2 — Verify

`notion-fetch` both databases and confirm:

**Tasks DB properties**

- `Task` (title)
- `Task ID`
- `상태`
- `작업 유형`
- `종속성`
- `관련 문서` → relation to Docs
- `Blocked by` → relation to Tasks (self)
- `Blocking` → relation to Tasks (self)

**Docs DB properties**

- `Name` (title)
- `태그`
- `상태`
- `관련 태스크` → relation to Tasks (synced from Tasks.`관련 문서`)

## Failure handling

- If a relation already exists (re-run), fetch schema and skip duplicate ALTER.
- If dual relation names differ, note in `.ssot/config.json` only after user confirms — do not rename Notion properties without approval.
