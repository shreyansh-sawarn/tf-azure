include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/monitoring/diagnostic_setting"
}

dependency "storage" {
  config_path = "../storage_account"
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
  name               = "diag-st"
  target_resource_id = "${dependency.storage.outputs.id}/blobServices/default"
  workspace_id       = dependency.log_analytics.outputs.id
  log_categories     = ["StorageRead", "StorageWrite", "StorageDelete"]
}
