variable "function_app_name" {
  type        = string
  description = "Name of the Function App"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "service_plan_id" {
  type        = string
  description = "ID of the App Service Plan"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name for the function app"
}

variable "storage_account_access_key" {
  type        = string
  sensitive   = true
  description = "Storage account access key"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
