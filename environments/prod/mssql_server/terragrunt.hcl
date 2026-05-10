include "root" { path = find_in_parent_folders() }
terraform { source = "../../../modules/database/mssql_server" }
dependency "resource_group" { config_path = "../resource_group" }
locals { env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")) }
inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  name                = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-sql"
  admin_password      = "StrongP@ssw0rd!Prod123"
}
