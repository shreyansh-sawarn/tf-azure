variable "name" {
  type        = string
  description = "Name of the Log Analytics Workspace"
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "sku" {
  type        = string
  default     = "PerGB2018"
  description = "The SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018."
  validation {
    condition     = contains(["Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation", "PerGB2018"], var.sku)
    error_message = "The sku must be a valid Log Analytics Workspace SKU."
  }
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "The workspace data retention in days"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}
