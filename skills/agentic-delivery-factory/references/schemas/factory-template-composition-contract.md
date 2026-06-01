# Factory Template Composition Contract

**Status**: Draft v0.1  
**Scope**: Bootstrap Skill Bundle runtime, Factory Templates, Stack Ports, Stack Adapters, node-document seeding, adapter skill install, and implementation gate composition.

This document fixes the vocabulary and target data model for the next ADF bootstrap layer. It intentionally replaces the ambiguous "profile" vocabulary with **Composition Contract** and keeps "profile" only as a legacy config field until a migration is implemented.

## 1. Vocabulary

| Term | Contract |
|---|---|
| Bootstrap Skill Bundle | `skills/agentic-delivery-factory/`; installs the operating layer for an instance factory. |
| Factory Template | User-selectable product/factory package, e.g. `factory.web-saas.001`. It owns repo scaffold shape, required Stack Ports, default Stack Adapters, and required node-document sets. |
| Stack Port | Abstract capability slot required by a Factory Template, e.g. `port.database`, `port.auth`, `port.hosting`, `port.ui-kit`. |
| Stack Adapter | Concrete implementation attached to a Stack Port, e.g. `stk.supabase-db`, `stk.vercel`, `stk.shadcn-ui`. It contributes skills, policies, gates, env vars, and optional scaffold fragments. |
| Composition Contract | Deterministic output of `Factory Template + selected Stack Adapters`. It lists required node types, policy seeds, policy contributions, adapter skills, scaffold fragments, and gate rows. |
| Implementation Gate | Runtime blocker table generated from the Composition Contract and stored in the instance Knowledge Graph as an Implementation Gate Policy node. |
| Catalog Writing Template | Notion Catalog page body for writing a document type. This is not a Factory Template and must not be stored in repo JSON. |

## 2. End-to-end bootstrap order

### 2.1 Select Factory Template

The user starts the Bootstrap Skill Bundle and chooses a Factory Template:

```text
factory.web-saas.001
```

The template is the user-facing selection unit. It is not a Stack Adapter and not a legacy delivery profile. It describes what kind of factory instance will be created and which Stack Ports must be satisfied.

### 2.2 Install operating layer

The Bootstrap Skill Bundle performs the common factory installation:

1. Create/adopt Notion project page.
2. Create/adopt Goals, Catalog, Knowledge Nodes, Knowledge Edges, and Tasks DBs.
3. Install project workflow skills:
   - task workflow
   - node authoring
   - edge workflow
   - documentation workflow
   - implementation workflow
   - reconciliation
4. Render `AGENTS.md`.
5. Render `.adf/config.json`.
6. Seed bootstrap goals, starter nodes, starter edges, and starter tasks.

This operating layer is mostly replicated for every Factory Template. It does not decide product stack shape by itself.

### 2.3 Resolve Stack Ports

The Factory Template declares required Stack Ports. Each required port must resolve to one Stack Adapter:

```text
port.hosting  -> stk.vercel
port.database -> stk.supabase-db
port.auth     -> stk.supabase-auth
port.ui-kit   -> stk.shadcn-ui
port.e2e      -> stk.playwright-e2e
```

Default adapters may be accepted as-is or swapped when compatible adapters exist. Port compatibility is validated before repo scaffold or gate composition.

### 2.4 Compose repo scaffold

The Factory Template provides the base repo scaffold. Stack Adapters add scaffold fragments. For `factory.web-saas.001`, the base scaffold is expected to include:

- Next.js app structure
- shared package layout or app-local packages
- Storybook/OpenPencil surface for design/component feedback
- Cursor/ADF skill references
- baseline env templates
- test harness entry points

Adapters add only the files or instructions they own. For example, a database adapter may add migration folders and DB client boundaries; a UI adapter may add component conventions and Storybook stories.

### 2.5 Compose required node documents

The Factory Template turns on a subset of the full Document Type Catalog. The Catalog remains the dictionary of possible document types; the Factory Template selects the required set for this factory.

Required node documents fall into three lifecycle classes:

| Lifecycle class | Examples | Authoring mode |
|---|---|---|
| Project-specific persistent | Project Brief, Information Architecture baseline, Architecture Overview | Human + agent co-author at project start because these capture intent. |
| Work-specific ephemeral/current | PRD, Test Plan, Test Run Report, Design QA Checklist | Created per task, release, or verification loop. |
| Environment-specific policy | Component Policy, Test Strategy, QA Environment & Test Data Policy, E2E Scenario List, adapter policy nodes | Agent drafts from Factory Template + Stack Adapter contributions; human can review before Active. |

The Factory Template should not instantiate all 71 catalog types. It should switch on the minimal catalog set needed for the selected surface and adapters.

### 2.6 Install adapter skills

Each Stack Adapter may define skill references. The Bootstrap Skill Bundle copies those adapter skills or runbooks into the same project skills area as the operating skills.

Operating skills are stack-agnostic. Adapter skills are stack-specific and should be invoked by gate rows, verification tasks, or documentation workflow instructions.

### 2.7 Merge adapter policy contributions

Each Stack Adapter can provide:

- stack-owned policy nodes
- required sections for environment policy docs
- gate rows
- verification evidence requirements
- skill refs/runbooks

The composer merges these into the Composition Contract. It must dedupe by stable IDs:

- node type name for required catalog types
- `policyRole` for policy seeds
- `(targetPolicyRole, sourceAdapterId)` for policy contributions
- `checkId` for gate rows
- skill path for adapter skill refs

### 2.8 Write Implementation Gate Policy

The composer writes a Draft Implementation Gate Policy node from the Composition Contract. It includes:

- selected Factory Template
- resolved Stack Ports and Stack Adapters
- required project-specific docs
- required environment policies
- adapter policy seeds
- policy contributions
- implementation gate rows
- verification gate rows
- adapter skill refs
- unresolved conflicts

The implementation workflow blocks product implementation until required gate nodes are Active according to run mode and gate rules.

## 3. Data model

### 3.1 Factory Template manifest

Recommended path:

```text
references/templates/factories/factory.web-saas.001.json
```

Schema intent:

```json
{
  "templateVersion": "0.1",
  "factoryTemplateId": "factory.web-saas.001",
  "label": "Web SaaS 001",
  "surface": "surf.web-saas",
  "description": "Full-stack web SaaS factory template with a port-based stack model.",
  "requiredPorts": [
    "port.hosting",
    "port.database",
    "port.auth",
    "port.ui-kit",
    "port.e2e",
    "port.component-catalog"
  ],
  "optionalPorts": [
    "port.object-storage",
    "port.email",
    "port.analytics",
    "port.payments",
    "port.workflow"
  ],
  "defaultAdapters": {
    "port.hosting": "stk.vercel",
    "port.database": "stk.supabase-db",
    "port.auth": "stk.supabase-auth",
    "port.ui-kit": "stk.shadcn-ui",
    "port.e2e": "stk.playwright-e2e",
    "port.component-catalog": "stk.storybook-openpencil"
  },
  "requiredNodeTypes": {
    "projectPersistent": [
      "Project Brief",
      "Architecture Overview",
      "Information Architecture"
    ],
    "environmentPolicy": [
      "Component Policy",
      "Accessibility Baseline",
      "Test Strategy",
      "QA Environment & Test Data Policy",
      "E2E Scenario List"
    ],
    "workSpecific": [
      "PRD",
      "Functional Spec",
      "API Spec",
      "Tech Spec",
      "Data Model Spec",
      "Test Plan",
      "Test Run Report",
      "Design QA Checklist"
    ]
  },
  "repoScaffold": {
    "base": "nextjs-app-router",
    "includes": [
      "storybook",
      "openpencil",
      "cursor-skills",
      "env-template",
      "test-harness"
    ],
    "paths": [
      "apps/web",
      "packages/domain",
      "packages/ui",
      "packages/test",
      "docs",
      ".cursor/skills"
    ]
  },
  "gatePolicy": {
    "mode": "full",
    "blocksFirstProductImplementation": true
  }
}
```

### 3.2 Stack Port registry

Recommended path:

```text
references/templates/ports/port.database.json
```

Schema intent:

```json
{
  "portVersion": "0.1",
  "portId": "port.database",
  "label": "Database",
  "requiredInterface": {
    "mustProvide": [
      "compatibleSurfaces",
      "policySeeds",
      "gateCandidates"
    ],
    "mayProvide": [
      "policyContributions",
      "catalogCandidates",
      "skillRefs",
      "envVars",
      "repoScaffold"
    ]
  },
  "selectionRules": {
    "oneAdapterOnly": true,
    "allowNone": false
  }
}
```

### 3.3 Stack Adapter manifest

Current v1 manifest schema path:

```text
references/schemas/stack-adapter-manifest.schema.json
```

Current adapter manifest paths remain:

```text
references/presets/stk.*.manifest.json
```

The filename `preset-manifest.schema.json` is deprecated because "preset" hides the real role. These files define Stack Adapters.

Current v1 fields:

```json
{
  "manifestVersion": "1.0",
  "stackId": "stk.supabase",
  "label": "Supabase",
  "compatibleSurfaces": ["surf.web-saas"],
  "policySeeds": [],
  "policyContributions": [],
  "catalogCandidates": [],
  "gateCandidates": {
    "implementation": [],
    "verification": []
  },
  "skillRefs": [],
  "compatibilityHints": {
    "requires": [],
    "conflicts": []
  }
}
```

Target v2 fields:

```json
{
  "manifestVersion": "2.0",
  "adapterId": "stk.supabase-db",
  "label": "Supabase Database",
  "providesPort": "port.database",
  "compatibleSurfaces": ["surf.web-saas", "surf.api-backend"],
  "compatibleFactoryTemplates": ["factory.web-saas.001"],
  "policySeeds": [
    {
      "policyRole": "policy.supabase-data-auth",
      "title": "Supabase data/RLS/migration policy"
    }
  ],
  "policyContributions": [
    {
      "targetPolicyRole": "policy.test-strategy",
      "targetCatalogType": "Test Strategy",
      "requiredSections": [
        "RLS access matrix",
        "migration smoke scope"
      ]
    }
  ],
  "gateCandidates": {
    "implementation": [
      {
        "checkId": "supabase-schema-change",
        "gateClass": "Data / schema change",
        "summary": "Schema/RLS work requires active data policy and current data model.",
        "requiredPolicyRoles": ["policy.supabase-data-auth"]
      }
    ],
    "verification": [
      {
        "checkId": "supabase-rls-access-matrix",
        "gateClass": "Data verification",
        "summary": "Test Run Report includes positive/negative role access evidence.",
        "skillRef": "references/presets/guides/stk.supabase-rls-review.md"
      }
    ]
  },
  "skillRefs": [
    "references/presets/guides/stk.supabase-rls-review.md"
  ],
  "scaffold": {
    "envVars": [
      "NEXT_PUBLIC_SUPABASE_URL",
      "NEXT_PUBLIC_SUPABASE_ANON_KEY",
      "SUPABASE_SERVICE_ROLE_KEY"
    ],
    "paths": [
      "supabase/migrations",
      "src/server/db"
    ],
    "commands": []
  }
}
```

### 3.4 Composition Contract

Recommended generated path in an instance repo:

```text
.adf/composition.json
```

The same content should also be rendered into the Draft Implementation Gate Policy node as a human-readable trace.

Schema intent:

```json
{
  "compositionVersion": "0.1",
  "compositionId": "composition.factory-web-saas-001.vercel-supabase-shadcn",
  "factoryTemplateId": "factory.web-saas.001",
  "surface": "surf.web-saas",
  "selectedAdapters": {
    "port.hosting": "stk.vercel",
    "port.database": "stk.supabase-db",
    "port.auth": "stk.supabase-auth",
    "port.ui-kit": "stk.shadcn-ui"
  },
  "requiredNodeTypes": {
    "projectPersistent": [],
    "environmentPolicy": [],
    "workSpecific": []
  },
  "policySeeds": [],
  "policyContributions": [],
  "adapterSkillInstallPlan": [],
  "repoScaffoldPlan": [],
  "implementationGateRows": [],
  "verificationGateRows": [],
  "conflicts": []
}
```

## 4. Composer rules

| Rule | Contract |
|---|---|
| C-001 | Factory Template chooses the surface and required Stack Ports. |
| C-002 | Every required Stack Port resolves to exactly one Stack Adapter unless the port explicitly allows none. |
| C-003 | Stack Adapters are not vendor bundles. Split adapters by replaceable capability when possible. |
| C-004 | The Catalog is the dictionary; Factory Template turns on only required catalog types. |
| C-005 | Project-specific persistent docs require human intent capture before Active. |
| C-006 | Environment-specific policies may be drafted by the agent from adapter defaults and contributions. |
| C-007 | Work-specific docs are seeded as task/release needs, not all at bootstrap. |
| C-008 | Adapter policy contributions merge into foundation policy docs; they do not create duplicate foundation docs. |
| C-009 | Adapter skills install beside operating skills but are invoked only by gates, tasks, or runbooks. |
| C-010 | Implementation Gate Policy is generated from the Composition Contract and blocks implementation according to active gate rules. |

## 5. Legacy naming migration

| Legacy term/path | New term/path | Migration rule |
|---|---|---|
| preset manifest | Stack Adapter manifest | Update prose and schema filenames. Keep `stk.*.manifest.json` adapter files until v2 IDs are defined. |
| `preset-manifest.schema.json` | `stack-adapter-manifest.schema.json` | Immediate rename. |
| delivery profile | Composition Contract | Stop using in new docs. Existing config field can remain until migration. |
| `profileId` | `compositionId` or `compositionContractId` | Future config migration. |
| capability stack / stack | Stack Adapter | Use "Stack Adapter" when the unit can be installed into a Stack Port. |
| capability slot | Stack Port | Use "Stack Port" for abstract slots. |

## 6. Storage plan

| Artifact | Factory repo source | Instance repo copy |
|---|---|---|
| Bootstrap Skill Bundle | `skills/agentic-delivery-factory/` | `.cursor/skills/*` plus copied references |
| Factory Template manifests | `references/templates/factories/*.json` | `references/templates/factories/*.json` |
| Stack Port registry | `references/templates/ports/*.json` | `references/templates/ports/*.json` |
| Stack Adapter manifests | `references/presets/stk.*.manifest.json` | selected manifests under `references/presets/` |
| Stack Adapter schema | `references/schemas/stack-adapter-manifest.schema.json` | copied schema reference when repo mirrors are enabled |
| Composition Contract | generated | `.adf/composition.json` + Implementation Gate Policy trace |
| Catalog Writing Templates | Notion Catalog page bodies | Notion Catalog page bodies |

## 7. Open implementation notes

1. Add `factory-template.schema.json`.
2. Add `stack-port.schema.json`.
3. Extend Stack Adapter schema to v2 with `providesPort`, `compatibleFactoryTemplates`, and `scaffold`.
4. Replace legacy `deliveryProfile.profileId` with `composition.compositionId` in `.adf/config.json` after a migration path exists.
5. Update wizard intake from "select surfaces/stacks/profile" to "select Factory Template, confirm default adapters, override ports if needed".
6. Render `.adf/composition.json` before writing the Implementation Gate Policy.
7. Keep the Notion Catalog as the only SSOT for document-writing templates.
