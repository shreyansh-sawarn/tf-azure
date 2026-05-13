include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "." # Uses the local main.tf in this folder
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
  vnet_name           = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-vnet"
  firewall_name       = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-fw"
  
  address_space       = ["10.1.0.0/16"]
  subnets = {
    web                 = { address_prefixes = ["10.1.1.0/24"] }
    app                 = { address_prefixes = ["10.1.2.0/24"] }
    db                  = { address_prefixes = ["10.1.3.0/24"] }
    AzureFirewallSubnet = { address_prefixes = ["10.1.4.0/24"] }
  }

  tags = local.env_vars.locals.tags
}
