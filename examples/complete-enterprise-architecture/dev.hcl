# Development Profile: Cost-Optimized
locals {
  environment    = "dev"
  project_prefix = "tfaz-demo-dev"
  location       = "eastus"

  # Compute settings
  vm_sku        = "Standard_B1s"
  node_count    = 2
  
  # Database settings
  db_sku         = "Basic"
  zone_redundant = false

  tags = {
    Environment = "dev"
    Example     = "complete-enterprise"
    ManagedBy   = "Terragrunt"
  }
}
