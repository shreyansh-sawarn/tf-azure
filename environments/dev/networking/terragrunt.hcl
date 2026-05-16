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
  app_gateway_name    = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-agw"
  
  address_space       = ["10.0.0.0/16"]
  subnets = {
    web                 = { address_prefixes = ["10.0.1.0/24"], service_endpoints = [] }
    app                 = { address_prefixes = ["10.0.2.0/24"], service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"] }
    db                  = { address_prefixes = ["10.0.3.0/24"], service_endpoints = ["Microsoft.Sql"] }
    AzureFirewallSubnet = { address_prefixes = ["10.0.4.0/24"], service_endpoints = [] }
    AppGatewaySubnet    = { address_prefixes = ["10.0.5.0/24"], service_endpoints = [] }
  }

  # DDoS Protection: Disabled by default for cost control.
  # In production, provide an existing DDoS Protection Plan ID:
  # ddos_protection_plan_id = "/subscriptions/.../ddosProtectionPlans/enterprise-ddos"
  ddos_protection_plan_id = null

  tags = local.env_vars.locals.tags
}
