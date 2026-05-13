include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/resource_group"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-rg"
  location            = local.env_vars.locals.location
  tags                = local.env_vars.locals.tags
}
