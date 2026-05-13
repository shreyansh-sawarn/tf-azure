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

  sql_server_name    = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-sql"
  sql_db_name        = "main-db"
  sql_admin_username = "sqladmin"
  sql_admin_password = "placeholder-for-portfolio-demo"

  storage_account_name = replace("${local.env_vars.locals.project_name}${local.env_vars.locals.environment}sa", "-", "")
  storage_replication  = "GRS"
  storage_containers   = ["backups", "logs", "prod-data"]
  
  sql_db_sku           = "S0"
}
