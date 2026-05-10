include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/web"
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "storage" {
  config_path = "../storage"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name        = dependency.resource_group.outputs.resource_group_name
  location                   = dependency.resource_group.outputs.location
  app_service_plan_name      = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-asp"
  app_service_name           = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-webapp"
  function_app_name          = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-func"
  storage_account_name       = dependency.storage.outputs.storage_account_name
  storage_account_access_key = dependency.storage.outputs.primary_access_key
}
