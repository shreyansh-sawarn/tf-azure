variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "os_type" {
  type        = string
  default     = "Linux"
  description = "Operating System type"
}

variable "sku_name" {
  type        = string
  default     = "B1"
  description = "SKU for the plan"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
