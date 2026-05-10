include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/web/app_service_plan"
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "eastus"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name   = dependency.resource_group.outputs.resource_group_name
  location              = dependency.resource_group.outputs.location
  app_service_plan_name = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-asp"
  sku_name              = "P1v2"
  tags                = local.env_vars.locals.tags
}
