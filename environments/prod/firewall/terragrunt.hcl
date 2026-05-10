include "root" { path = find_in_parent_folders() }
terraform { source = "../../../modules/networking/firewall" }
dependency "resource_group" { config_path = "../resource_group" }
dependency "vnet" { config_path = "../vnet" }
locals { env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")) }
inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  name                = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-fw"
  subnet_id           = dependency.vnet.outputs.subnet_ids["web"]
}
