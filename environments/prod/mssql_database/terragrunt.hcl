include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/database/mssql_database"
}

dependency "mssql_server" {
  config_path = "../mssql_server"
  mock_outputs = {
    id   = "mock-id"
    fqdn = "mock.database.windows.net"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  name           = "proddb"
  server_id      = dependency.mssql_server.outputs.id
  sku_name       = "GP_Gen5_2"
  zone_redundant = true
  tags           = local.env_vars.locals.tags
}
