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

dependency "networking" {
  config_path = "../networking"
  mock_outputs = {
    subnet_ids = { app = "mock-subnet-id" }
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = dependency.foundation.outputs.location
  tags                = local.env_vars.locals.tags
  subnet_id           = dependency.networking.outputs.subnet_ids["app"]

  availability_set_name = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-as"
  linux_vm_name         = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-linux-vm"
  windows_vm_name       = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-win-vm"
  lb_name               = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-internal-lb"

  admin_password       = "placeholder-for-portfolio-demo"
  admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD36I5TOn6oX/auxlLXlJH7UzZ4X3hByb9Vt+xTREu7VT3YXDuaN+3zmejU7Y/V/VIZia5X2Ezw7J7+YLLXSEtR5gVMs6eXJanUMcSyu0reia3xZw2uIfhbQgEtkNK83fjAZoq3WzRccy4omYZ9ii7J9bz14I4WeDF5O0CookeAMX5ZXTPkOrd3OjI2d/8lV3fbK2/ozcLydx3BzTfIDbCH16JBJzfa+8/+tQepYVmSEqQCUq73V40eQ+8DSxvAd2FId9VUnejheLUaPsl2Ou2CUDL2OrpdUPOWvjAh3/2slUJyynhIvJkrIUagFaNViqa9kavSd90yIuzG4IdwMoa5 test@example.com
"
}
