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
  linux_vm_name        = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-linux-vm"
  windows_vm_name      = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-win-vm"
  lb_name              = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-internal-lb"
  
  admin_password       = "placeholder-for-portfolio-demo"
  admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyZMOnA7PZ/m3NPeAY6rsh884iE45T+r8/64uUWCY1410t6T+p9OqL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV test@example.com"
}
