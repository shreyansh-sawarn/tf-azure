include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/web/web_app"
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

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  app_service_name    = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-webapp"
  service_plan_id     = dependency.app_service_plan.outputs.id
  tags                = local.env_vars.locals.tags
}
