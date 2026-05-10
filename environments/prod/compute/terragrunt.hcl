include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/compute"
}

dependency "resource_group" {
  config_path = "../resource_group"
}

dependency "networking" {
  config_path = "../networking"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  vm_name             = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-vm"
  subnet_id           = dependency.networking.outputs.subnet_ids["app"]
  vm_size             = "Standard_D2s_v3" # Upgraded for Prod
  admin_password      = "StrongP@ssw0rd!Prod"
}
