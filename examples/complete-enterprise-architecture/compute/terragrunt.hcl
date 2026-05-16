include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "."
}

dependency "foundation" {
  config_path = "../foundation"
}

dependency "networking" {
  config_path = "../networking"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = local.env_vars.locals.location
  name                = "${local.env_vars.locals.project_prefix}-vmss"
  sku                 = local.env_vars.locals.vm_sku
  instances           = local.env_vars.locals.node_count
  subnet_id           = dependency.networking.outputs.subnet_ids["compute"]
  
  admin_username       = "azureuser"
  admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyZMOnA7PZ/m3NPeAY6rsh884iE45T+r8/64uUWCY1410t6T+p9OqL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/r= test@example.com"
  
  tags = local.env_vars.locals.tags
}
