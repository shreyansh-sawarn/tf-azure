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
    vnet_id    = "mock-id"
    subnet_ids = { app = "mock-id" }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "storage" {
  config_path = "../storage_account"
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
  name                = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-st-pe"
  subnet_id           = dependency.vnet.outputs.subnet_ids["app"]
  vnet_id             = dependency.vnet.outputs.vnet_id
  target_resource_id  = dependency.storage.outputs.id
  subresource_names   = ["blob"]
  dns_zone_name       = "privatelink.blob.core.windows.net"
  tags                = local.env_vars.locals.tags
}
