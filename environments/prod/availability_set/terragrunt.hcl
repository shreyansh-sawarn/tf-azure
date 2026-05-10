include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/compute/availability_set"
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
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  name                = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-avset"
  tags                = local.env_vars.locals.tags
}
