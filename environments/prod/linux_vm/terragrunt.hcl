include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/compute/linux_vm"
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
    vnet_name  = "mock-vnet"
    subnet_ids = { app = "mock-id" }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "availability_set" {
  config_path = "../availability_set"
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
  name                = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-vm"
  subnet_id           = dependency.vnet.outputs.subnet_ids["app"]
  availability_set_id = dependency.availability_set.outputs.id
  vm_size             = "Standard_D2s_v3"
  admin_password      = "placeholder-for-portfolio-demo"
  tags                = local.env_vars.locals.tags
}
