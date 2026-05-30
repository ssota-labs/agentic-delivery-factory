# Init wizard — new project Notion SSOT bootstrap

Full procedure for **create** mode (new private Notion databases). For adopt mode, branch to [adopt-existing.md](adopt-existing.md) after Phase 0.

## Phase 0 — Collect inputs

Ask in one batch when possible (use AskQuestion if available):

| # | Field | Rules |
|---|---|---|
| 1 | Target repo path | Absolute path; must exist or user confirms create |
| 2 | `projectSlug` | kebab-case, e.g. `youpd-skills` |
| 3 | `projectName` | Display name |
| 4 | `taskIdPrefix` | Uppercase short prefix, e.g. `YPDS` |
| 5 | `githubRepo` | `org/repo` |
| 6 | Notion mode | `create` (this wizard) or `adopt` → other file |
| 7 | AGENTS profile | `minimal` or `full` |
| 8 | Seed P1.0 | yes/no — Blueprint page + PRD/DSGN/IMPL/VERF task rows |
| 9 | Skills install dir | `.cursor/skills` (default) or `.agents/skills` |

Summarize choices and get **explicit approval** before Phase 1 Notion writes.

## Phase 1 — Create Notion databases (create mode)

### 1.1 Tasks database

```
notion-create-database
  title: "{{PROJECT_NAME}} — 개발 태스크"
  description: "Development task SSOT for {{GITHUB_REPO}}"
  schema: <contents of references/schemas/tasks-database.ddl>
  parent: (omit — private workspace page)
```

### 1.2 Docs database

```
notion-create-database
  title: "{{PROJECT_NAME}} — 프로젝트 문서"
  description: "Linked docs SSOT for {{GITHUB_REPO}}"
  schema: <contents of references/schemas/docs-database.ddl>
  parent: (omit)
```

### 1.3 Fetch IDs

`notion-fetch` each new database. Extract:

- Public URL → `TASKS_DB_URL`, `DOCS_DB_URL`
- `data_source_id` from `<data-source>` tag → `TASKS_DS_ID`, `DOCS_DS_ID`

### 1.4 Relations

Follow [../schemas/relations-setup.md](../schemas/relations-setup.md) with collected IDs.

### 1.5 Optional seed

If user chose seed P1.0:

1. Create Blueprint page in Docs DB — body from [../schemas/seed-blueprint.md](../schemas/seed-blueprint.md)
2. Create task rows in Tasks DB (`notion-create-pages`, parent = `TASKS_DS_ID`):

| Task property `Task` | `Task ID` | `작업 유형` | `상태` |
|---|---|---|---|
| `{{TASK_PREFIX}}-P1.0-PRD` | same | PRD 작성 | 대기 |
| `{{TASK_PREFIX}}-P1.0-DSGN` | same | 설계 작성 | 대기 |
| `{{TASK_PREFIX}}-P1.0-IMPL` | same | 구현 | 대기 |
| `{{TASK_PREFIX}}-P1.0-VERF` | same | 검증 | 대기 |

3. Set `Blocked by` / link Blueprint in `관련 문서` when relations are ready (DSGN blocked by PRD, etc.)

## Phase 2 — Write target repo files

Read templates from this skill package:

- `references/templates/AGENTS.md.tpl`
- `references/templates/config.json.tpl`

Replace all placeholders (see contributor AGENTS.md in source repo). Write to target:

- `{target}/AGENTS.md`
- `{target}/.ssot/config.json`

For `full` profile, ensure wizard collected blocks for:

- Setup Commands
- Testing Instructions
- Code Style
- Pull Request Guidelines

If user skipped details, leave `{{FULL_PROFILE_*}}` sections with TODO comments.

## Phase 3 — Copy workflow skills

Source: `references/bundled/cursor-skills/`

For each folder, copy to `{target}/{SKILLS_INSTALL_DIR}/{{PROJECT_SLUG}}-{name}/`:

| Source folder | Target folder name |
|---|---|
| `documentation-workflow/` | `{{PROJECT_SLUG}}-documentation-workflow/` |
| `implementation-workflow/` | `{{PROJECT_SLUG}}-implementation-workflow/` |
| `reconciliation/` | `{{PROJECT_SLUG}}-reconciliation/` |
| `version-bootstrap/` | `{{PROJECT_SLUG}}-version-bootstrap/` |

When copying:

1. Replace all placeholders in every file (SKILL.md + references)
2. Fix relative links between skills (e.g. `../{{PROJECT_SLUG}}-reconciliation/SKILL.md`)
3. Do not copy placeholder folder names literally — use resolved `projectSlug`

## Phase 4 — Report

Return to user:

```
Notion SSOT bootstrap complete

Project: {{PROJECT_NAME}} ({{GITHUB_REPO}})
Tasks DB: {{TASKS_DB_URL}}
Docs DB: {{DOCS_DB_URL}}

Written:
- AGENTS.md
- .ssot/config.json
- {{SKILLS_INSTALL_DIR}}/{{PROJECT_SLUG}}-* (4 workflow skills)

Next: Open the target repo. Development requests should start from AGENTS.md → Development router.
Ensure Notion MCP stays connected in that workspace.
```

## Abort conditions

- Notion MCP unavailable
- User declined approval summary
- Schema verification failed after relation setup
- Target path not writable
