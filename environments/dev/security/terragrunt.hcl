include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "."
}

dependency "foundation" {
  config_path = "../foundation"
  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "eastus"
  }
}

dependency "data" {
  config_path = "../data"
  mock_outputs = {
    storage_account_id = "mock-id"
  }
}

dependency "integration" {
  config_path = "../integration"
  mock_outputs = {
    log_analytics_id = "mock-id"
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = dependency.foundation.outputs.location
  tags                = local.env_vars.locals.tags

  key_vault_name = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-kv"
  
  storage_account_id = dependency.data.outputs.storage_account_id
  log_analytics_id   = dependency.integration.outputs.log_analytics_id
}
