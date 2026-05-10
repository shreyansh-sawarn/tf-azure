locals {
  project_name = "tf-azure"
  environment  = "prod"
  location     = "West US" # Using a different region for prod
  tags = {
    Project     = "tf-azure"
    Environment = "prod"
    ManagedBy   = "Terragrunt"
    Owner       = "Operations"
  }
}
