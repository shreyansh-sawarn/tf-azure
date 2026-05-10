include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/storage"
}

dependency "resource_group" {
  config_path = "../resource_group"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name  = dependency.resource_group.outputs.resource_group_name
  location             = dependency.resource_group.outputs.location
  storage_account_name = replace("${local.env_vars.locals.project_name}${local.env_vars.locals.environment}st", "-", "")
  containers           = ["data", "logs"]
}
