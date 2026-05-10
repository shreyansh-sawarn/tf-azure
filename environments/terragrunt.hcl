locals {
  # Load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract variables for easy access
  project_name = local.env_vars.locals.project_name
  environment  = local.env_vars.locals.environment
  location     = local.env_vars.locals.location
}

# Generate an Azure provider block
generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000" # Placeholder
}
EOF
}

# Configure remote state management
# Note: For portfolio purposes, we define the structure but skip actual bucket creation
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "${local.project_name}-terraform-state-rg"
    storage_account_name = replace("${local.project_name}tfstate", "-", "")
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Combine all variables to be passed to modules
inputs = merge(
  local.env_vars.locals,
)
