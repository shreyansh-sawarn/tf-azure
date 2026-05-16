# Root Terragrunt configuration for the Enterprise Example
# This generates the provider and handles common logic.

locals {
  # Load the active environment profile (dev.hcl or prod.hcl)
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  content   = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

# In an example, we use local state for ease of use
remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

# Pass common variables to all stacks
inputs = merge(
  local.env_vars.locals,
)
