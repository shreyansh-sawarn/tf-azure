variable "app_service_name" {
  type        = string
  description = "Name of the Web App"
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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
