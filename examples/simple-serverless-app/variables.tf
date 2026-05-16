variable "project_prefix" {
  type        = string
  description = "Prefix for all resources"
  default     = "tfazserverless"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Administrator password for SQL Server"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "demo"
    Project     = "serverless-app-example"
    ManagedBy   = "Terraform"
  }
}
