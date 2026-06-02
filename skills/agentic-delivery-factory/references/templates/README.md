# Template placeholders

| Placeholder | Meaning |
|---|---|
| `{{PROJECT_SLUG}}` | kebab-case project slug |
| `{{PROJECT_NAME}}` | human display name |
| `{{PROJECT_OVERVIEW}}` | one-line project description |
| `{{TASK_PREFIX}}` | task ID prefix |
| `{{GITHUB_REPO}}` | org/repo |
| `{{INTEGRATION_BRANCH}}` | branch used by scheduled agent PRs |
| `{{RELEASE_BRANCH}}` | human promotion branch |
| `{{PROJECT_URL}}` | Notion project page URL |
| `{{GOALS_DB_URL}}` / `{{GOALS_DS_ID}}` | Goals database URL / data source ID |
| `{{CATALOG_DB_URL}}` / `{{CATALOG_DS_ID}}` | Catalog database URL / data source ID |
| `{{NODES_DB_URL}}` / `{{NODES_DS_ID}}` | Knowledge Nodes database URL / data source ID |
| `{{EDGES_DB_URL}}` / `{{EDGES_DS_ID}}` | Knowledge Edges database URL / data source ID |
| `{{TASKS_DB_URL}}` / `{{TASKS_DS_ID}}` | Tasks database URL / data source ID |
| `{{SKILLS_INSTALL_DIR}}` | `.cursor/skills` or `.agents/skills` |
| `{{FACTORY_TEMPLATE_ID}}` | selected Factory Template ID, e.g. `factory.web-saas.001` |
| `{{BOOTSTRAP_DATE}}` | ISO date |
| `{{DELIVERY_SURFACES_JSON}}` | JSON array, e.g. `["surf.web-saas"]` |
| `{{DELIVERY_STACKS_JSON}}` | JSON array, e.g. `["apt.vercel","apt.supabase"]` |
| `{{GATE_MODE}}` | `full` or `legacy` |
| `{{PROFILE_ID}}` | resolved profile alias or empty string |
| `{{COMPOSITION_ID}}` | generated composition contract ID, e.g. `comp.my-project.001` |
| `{{COMPOSED_AT}}` | ISO-8601 timestamp for composition merge |
| `{{PRIMARY_SURFACE}}` | primary surface ID, e.g. `surf.web-saas` |
| `{{PROFILE_MATRIX_VERSION}}` | bundled delivery profile matrix version |
| `{{SELECTED_ADAPTERS_JSON}}` | JSON object mapping `port.*` → `apt.*` |
| `{{REQUIRED_NODE_TYPES_JSON}}` | JSON object with `projectPersistent`, `environmentPolicy`, `workSpecific` arrays |
| `{{POLICY_SEEDS_JSON}}` | merged policy seed array from composer |
| `{{POLICY_CONTRIBUTIONS_JSON}}` | merged policy contribution array from composer |
| `{{ADAPTER_SKILL_INSTALL_PLAN_JSON}}` | adapter skill install plan array |
| `{{REPO_SCAFFOLD_PLAN_JSON}}` | repo scaffold plan object from Factory Template + adapters |
| `{{IMPLEMENTATION_GATE_ROWS_JSON}}` | implementation gate rows array |
| `{{VERIFICATION_GATE_ROWS_JSON}}` | verification gate rows array |
| `{{CONFLICTS_JSON}}` | conflict array (`[]` when clean) |
| `{{ADAPTER_MANIFEST_PATHS_JSON}}` | JSON array of selected adapter manifest paths |

`.adf/config.json` also records:

| Field | Meaning |
|---|---|
| `bootstrapVersion` | shipped bootstrap contract version (currently `0.5`) |
| `profileMatrixVersion` | bundled delivery profile matrix version (currently `1.3.3`) |
| `workflowVersion` | stage map version (currently `1.3`) |
| `factoryTemplate.factoryTemplateId` | selected user-facing Factory Template |
| `factoryTemplate.sourcePath` | copied Factory Template JSON source path |
| `composition.compositionId` | generated Composition Contract ID |
| `composition.sourcePath` | repo-local machine-readable composition trace |
| `composition.schemaPath` | JSON schema for `.adf/composition.json` |
| `deliveryProfile.surfaces` | selected surface IDs |
| `deliveryProfile.stacks` | selected stack preset IDs |
| `deliveryProfile.gateMode` | `full` (dynamic composer) or `legacy` (v0.4 static gate) |
| `deliveryProfile.profileId` | legacy reference profile alias when intake matches Matrix §6.1; new Factory Template work should prefer a generated Composition Contract |
| `taskPolicyVersion` | task responsibility unit policy version (currently `1.0`) |
| `catalogSourceUrl` | canonical ADF catalog source used for duplicate/adopt |
| `catalogMigrationVersion` | latest catalog migration applied to the instance |
| `automation.integrationBranch` | branch used by the Dev Task Loop automation |
| `automation.releaseBranch` | branch reserved for human promotion |
| `automation.autoCompleteOnScheduler` | whether scheduled runs may mark tasks `완료` after gates pass |
