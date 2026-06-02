{
  "$schema": "../references/schemas/composition-contract.schema.json",
  "compositionVersion": "1.0",
  "compositionId": "comp.{{PROJECT_SLUG}}.001",
  "composedAt": "{{COMPOSED_AT}}",
  "factoryTemplateId": "{{FACTORY_TEMPLATE_ID}}",
  "surface": "{{PRIMARY_SURFACE}}",
  "gateMode": "{{GATE_MODE}}",
  "legacyProfileId": "{{PROFILE_ID}}",
  "selectedAdapters": {{SELECTED_ADAPTERS_JSON}},
  "requiredNodeTypes": {{REQUIRED_NODE_TYPES_JSON}},
  "policySeeds": {{POLICY_SEEDS_JSON}},
  "policyContributions": {{POLICY_CONTRIBUTIONS_JSON}},
  "adapterSkillInstallPlan": {{ADAPTER_SKILL_INSTALL_PLAN_JSON}},
  "repoScaffoldPlan": {{REPO_SCAFFOLD_PLAN_JSON}},
  "implementationGateRows": {{IMPLEMENTATION_GATE_ROWS_JSON}},
  "verificationGateRows": {{VERIFICATION_GATE_ROWS_JSON}},
  "conflicts": {{CONFLICTS_JSON}},
  "sourceTrace": {
    "factoryTemplatePath": "references/templates/factories/{{FACTORY_TEMPLATE_ID}}.json",
    "adapterManifestPaths": {{ADAPTER_MANIFEST_PATHS_JSON}},
    "profileMatrixVersion": "{{PROFILE_MATRIX_VERSION}}",
    "gatePolicyNodeKey": "{{PROJECT_SLUG}}.delivery-workflow.implementation-gate-policy",
    "composerProcedurePath": "references/schemas/policy-composer.md"
  }
}
