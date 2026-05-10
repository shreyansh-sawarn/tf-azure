locals {
  project_name = "tf-azure"
  environment  = "dev"
  location     = "East US"
  tags = {
    Project     = "tf-azure"
    Environment = "dev"
    ManagedBy   = "Terragrunt"
  }
}
