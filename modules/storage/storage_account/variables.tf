variable "name" {
  type        = string
  description = "Name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Tier of the storage account"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be either 'Standard' or 'Premium'."
  }
}

variable "replication_type" {
  type        = string
  default     = "GRS"
  description = "Replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
}

variable "containers" {
  type        = list(string)
  default     = []
  description = "List of containers to create"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
