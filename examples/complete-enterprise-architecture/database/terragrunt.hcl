include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/database/mssql_server"
}

dependency "foundation" {
  config_path = "../foundation"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = local.env_vars.locals.location
  name                = "${local.env_vars.locals.project_prefix}-sql"
  admin_username      = "sqladmin"
  admin_password      = "ChangeMe123!@#Complex" # Placeholder
  
  tags = local.env_vars.locals.tags
}
