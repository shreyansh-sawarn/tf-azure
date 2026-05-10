include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/database"
}

dependency "resource_group" {
  config_path = "../resource_group"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  sql_server_name     = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-sql"
  sql_db_name         = "proddb"
  sku_name            = "GP_Gen5_2" # Upgraded for Prod Performance
  admin_password      = "StrongP@ssw0rd!Prod"
}
