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

dependency "security" {
  config_path = "../security"
  mock_outputs = {
    key_vault_id = "mock-id"
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
  key_vault_id        = dependency.security.outputs.key_vault_id

  availability_set_name = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-as"
  linux_vm_name        = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-linux-vm"
  linux_vm_size        = "Standard_DS1_v2"
  windows_vm_name      = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-win-vm"
  windows_vm_size      = "Standard_D2s_v3"
  lb_name              = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-internal-lb"
  
  admin_password       = "placeholder-for-portfolio-demo"
  admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8zf9vHSA7OtQwWnexPIq8pSfrcb4L4/3jLb6sAF39oxJa/tLCtADt9WfcOt72a6MSukfXZYaXE0RD1NdlHyQ5wigk2k+WOEg+HxXjNpXU5jnx3OVTjWrV0GwVZcMCurYUrYFQ+1aJk92X2q28XBuImgtSu3yKI6+Llthou0PONyvhrvaLs+DpaAy0mOGLbu++gYg+SSLZaUJnRtb5dv6Ju03quA1lRBJHKU1auhNGtN5YkXQQJwEPg== test@example.com"
}
