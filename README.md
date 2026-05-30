# notion-dev-ssot

Notion을 **개발 SSOT**(Single Source of Truth)로 쓰는 프로젝트를 에이전트가 직접 세팅하는 [Agent Skill](https://skills.sh) 패키지입니다.

- Private Notion **개발 태스크 DB** + **문서 DB** 생성(또는 기존 DB adopt)
- 대상 repo에 **`AGENTS.md`**, **`.ssot/config.json`**, **`.cursor/skills/{projectSlug}-*`** 워크플로 스킬 설치
- youpd-skills에서 검증된 Development router / documentation / implementation / reconciliation / version-bootstrap 패턴 일반화

## Prerequisites

- [Notion MCP](https://cursor.com) (Cursor Notion workspace plugin) 연결
- 대상 Git repository (로컬 경로)

## Install (skills.sh)

```bash
npx skills add ssota-labs/notion-dev-ssot@notion-dev-ssot
```

또는 Claude Code plugin / marketplace 경로로 `skills/` 디렉터리를 설치합니다.

## Usage

대상 프로젝트 workspace에서 에이전트에게 요청:

```text
이 프로젝트 Notion SSOT 세팅해줘
```

또는:

```text
AGENTS.md 만들고 Notion 개발 태스크 보드 연결해줘
```

에이전트는 `notion-dev-ssot` 스킬을 로드한 뒤 `references/init/wizard.md` 절차를 따릅니다.

### Init flow (요약)

1. 프로젝트 slug, task prefix, GitHub repo 등 질문
2. Notion private DB 2개 생성 **또는** 기존 URL adopt
3. Relation 연결 (`관련 문서`, `Blocked by`, `Blocking`)
4. `AGENTS.md`, `.ssot/config.json` 생성
5. `{slug}-documentation-workflow` 등 4개 workflow skill 복사

### Adopt existing Notion

```text
기존 Notion 개발 태스크/문서 DB URL로 adopt해줘
```

→ `references/init/adopt-existing.md` + schema verification

## Package layout

```text
skills/notion-dev-ssot/
  SKILL.md                 # Router
  references/
    init/                  # wizard, adopt, verify
    schemas/               # Notion DDL + relations
    templates/             # AGENTS.md.tpl, config.json.tpl
    bundled/cursor-skills/ # Copied into target project on init
```

## Placeholders (init 시 치환)

| Placeholder | Meaning |
|---|---|
| `{{PROJECT_SLUG}}` | kebab-case (skill folder prefix) |
| `{{PROJECT_NAME}}` | Display name |
| `{{TASK_PREFIX}}` | Task ID prefix (e.g. `YPDS`) |
| `{{GITHUB_REPO}}` | `org/repo` |
| `{{TASKS_DB_URL}}` / `{{DOCS_DB_URL}}` | Notion database URLs |
| `{{SKILLS_INSTALL_DIR}}` | `.cursor/skills` (default) |

## Optional: Notion MCP in target repo

Cursor에서 Notion 도구를 쓰려면 대상 repo에 Notion plugin MCP가 활성화되어 있어야 합니다. Cursor Settings → MCP → Notion workspace plugin.

## Manual verification checklist

After changing this package:

1. `wc -l skills/notion-dev-ssot/SKILL.md` — router ≤200 lines
2. `rg '{{PROJECT_SLUG}}' skills/notion-dev-ssot/references/bundled` — placeholders present in all 4 skills
3. Dry-run wizard against a throwaway repo (no commit) and confirm:
   - `AGENTS.md` Development router links resolve to `{slug}-*` skills
   - `.ssot/config.json` parses as JSON after placeholder replacement
4. Adopt path: `verify-schema.md` reports missing properties without auto-ALTER

## License

MIT — ssota-labs
