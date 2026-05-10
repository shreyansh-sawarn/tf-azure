variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "tf-azure"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project     = "tf-azure"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
