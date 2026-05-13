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

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = dependency.foundation.outputs.location
  tags                = local.env_vars.locals.tags

  log_analytics_name = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-law"
  log_retention_days = 90
  acr_name           = replace("${local.env_vars.locals.project_name}${local.env_vars.locals.environment}acr", "-", "")
  acr_sku            = "Premium"
  service_bus_name   = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-sb"
  logic_app_name     = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-logic"
}
