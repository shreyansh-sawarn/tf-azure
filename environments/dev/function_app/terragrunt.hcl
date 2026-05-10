include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/web/function_app"
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "eastus"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "app_service_plan" {
  config_path = "../app_service_plan"
  mock_outputs = {
    id = "mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "storage" {
  config_path = "../storage_account"
  mock_outputs = {
    name                = "mockstorage"
    primary_access_key  = "mock-key"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name        = dependency.resource_group.outputs.resource_group_name
  location                   = dependency.resource_group.outputs.location
  function_app_name          = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-func"
  service_plan_id            = dependency.app_service_plan.outputs.id
  storage_account_name       = dependency.storage.outputs.name
  storage_account_access_key = dependency.storage.outputs.primary_access_key
  tags                       = local.env_vars.locals.tags
}
