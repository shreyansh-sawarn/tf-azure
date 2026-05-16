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

dependency "integration" {
  config_path = "../integration"
  mock_outputs = {
    log_analytics_id = "mock-id"
    acr_id           = "mock-acr-id"
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  resource_group_name = dependency.foundation.outputs.resource_group_name
  location            = dependency.foundation.outputs.location
  tags                = local.env_vars.locals.tags
  
  cluster_name        = "${local.env_vars.locals.project_name}-${local.env_vars.locals.environment}-aks"
  dns_prefix          = "${local.env_vars.locals.project_name}${local.env_vars.locals.environment}"
  
  subnet_id           = dependency.networking.outputs.subnet_ids["app"]
  log_analytics_id    = dependency.integration.outputs.log_analytics_id
  acr_id              = dependency.integration.outputs.acr_id
}
