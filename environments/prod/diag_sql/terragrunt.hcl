include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/monitoring/diagnostic_setting"
}

dependency "mssql_server" {
  config_path = "../mssql_server"
  mock_outputs = {
    id = "mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "log_analytics" {
  config_path = "../log_analytics"
  mock_outputs = {
    id = "mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  name               = "diag-sql"
  target_resource_id = dependency.mssql_server.outputs.id
  workspace_id       = dependency.log_analytics.outputs.id
  log_categories     = ["SQLSecurityAuditEvents"]
}
