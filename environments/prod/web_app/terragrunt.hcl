include "root" { path = find_in_parent_folders() }
terraform { source = "../../../modules/web/web_app" }
dependency "resource_group" { config_path = "../resource_group" }
dependency "app_service_plan" { config_path = "../app_service_plan" }
locals { env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")) }
inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = dependency.resource_group.outputs.location
  app_service_name    = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-webapp"
  service_plan_id     = dependency.app_service_plan.outputs.id
}
