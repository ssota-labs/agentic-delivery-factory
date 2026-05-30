# Placeholder reference for AGENTS.md.tpl

## Required placeholders (always replace)

| Placeholder | Example |
|---|---|
| `{{PROJECT_SLUG}}` | `youpd-skills` |
| `{{PROJECT_NAME}}` | `youpd-skills` |
| `{{PROJECT_OVERVIEW}}` | One-line project description from wizard |
| `{{TASK_PREFIX}}` | `YPDS` |
| `{{GITHUB_REPO}}` | `ssota-labs/youpd-skills` |
| `{{TASKS_DB_URL}}` | Notion tasks URL |
| `{{DOCS_DB_URL}}` | Notion docs URL |
| `{{SKILLS_INSTALL_DIR}}` | `.cursor/skills` |

## Full profile — replace `{{FULL_PROFILE_SECTIONS}}`

For `minimal` profile, replace with empty string or a single line: `See README.md for setup and testing.`

For `full` profile, insert sections from wizard answers:

```markdown
## Setup Commands

{{SETUP_COMMANDS}}

## Development Workflow

{{DEV_WORKFLOW}}

## Testing Instructions

{{TESTING_INSTRUCTIONS}}

## Code Style

{{CODE_STYLE}}

## Pull Request Guidelines

{{PR_GUIDELINES}}
```

## config.json.tpl additional placeholder

| Placeholder | Example |
|---|---|
| `{{TASKS_DS_ID}}` | UUID from notion-fetch |
| `{{DOCS_DS_ID}}` | UUID from notion-fetch |
| `{{BOOTSTRAP_DATE}}` | ISO date `2026-05-30` |
