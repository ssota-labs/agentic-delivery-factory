{
  "version": 1,
  "bootstrapVersion": "0.4",
  "workflowVersion": "1.3",
  "taskPolicyVersion": "1.0",
  "catalogSourceUrl": "https://www.notion.so/371346dac45681e89a65c51ec5825017",
  "catalogMigrationVersion": "0.2",
  "projectSlug": "{{PROJECT_SLUG}}",
  "projectName": "{{PROJECT_NAME}}",
  "taskIdPrefix": "{{TASK_PREFIX}}",
  "githubRepo": "{{GITHUB_REPO}}",
  "skillsInstallDir": "{{SKILLS_INSTALL_DIR}}",
  "automation": {
    "mode": "scheduler-and-sweep",
    "integrationBranch": "{{INTEGRATION_BRANCH}}",
    "releaseBranch": "{{RELEASE_BRANCH}}",
    "autoCompleteOnScheduler": true,
    "devTaskLoopCron": "*/5 * * * *",
    "dailyReconciliationCron": "0 9 * * *"
  },
  "notion": {
    "projectUrl": "{{PROJECT_URL}}",
    "goalsDatabaseUrl": "{{GOALS_DB_URL}}",
    "goalsDataSourceId": "{{GOALS_DS_ID}}",
    "catalogDatabaseUrl": "{{CATALOG_DB_URL}}",
    "catalogDataSourceId": "{{CATALOG_DS_ID}}",
    "nodesDatabaseUrl": "{{NODES_DB_URL}}",
    "nodesDataSourceId": "{{NODES_DS_ID}}",
    "edgesDatabaseUrl": "{{EDGES_DB_URL}}",
    "edgesDataSourceId": "{{EDGES_DS_ID}}",
    "tasksDatabaseUrl": "{{TASKS_DB_URL}}",
    "tasksDataSourceId": "{{TASKS_DS_ID}}"
  },
  "bootstrappedAt": "{{BOOTSTRAP_DATE}}"
}
