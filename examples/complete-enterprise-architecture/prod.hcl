# Production Profile: High Availability
locals {
  environment    = "prod"
  project_prefix = "tfaz-demo-prod"
  location       = "westus"

  # Compute settings
  vm_sku        = "Standard_DS1_v2"
  node_count    = 3
  
  # Database settings
  db_sku         = "S0"
  zone_redundant = true

  tags = {
    Environment = "prod"
    Example     = "complete-enterprise"
    ManagedBy   = "Terragrunt"
  }
}
