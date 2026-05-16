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
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = local.env_vars.locals.location
  vnet_name           = "${local.env_vars.locals.project_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  
  subnets = {
    compute = { address_prefixes = ["10.0.1.0/24"], service_endpoints = [] }
    data    = { address_prefixes = ["10.0.2.0/24"], service_endpoints = ["Microsoft.Sql"] }
  }

  tags = local.env_vars.locals.tags
}
