variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "Name of the Web App"
  type        = string
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name for the Function App"
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage account access key for the Function App"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
