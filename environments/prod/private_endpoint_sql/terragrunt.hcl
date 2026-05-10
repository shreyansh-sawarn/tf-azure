include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/networking/private_endpoint"
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    resource_group_name = "mock-rg"
    location            = "eastus"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "vnet" {
  config_path = "../vnet"
  mock_outputs = {
    vnet_id = "mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "mssql_server" {
  config_path = "../mssql_server"
  mock_outputs = {
    id = "mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  name                = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-sql-pe"
  subnet_id           = dependency.vnet.outputs.subnet_ids["db"]
  vnet_id             = dependency.vnet.outputs.vnet_id
  target_resource_id  = dependency.mssql_server.outputs.id
  subresource_names   = ["sqlServer"]
  dns_zone_name       = "privatelink.database.windows.net"
  tags                = local.env_vars.locals.tags
}
