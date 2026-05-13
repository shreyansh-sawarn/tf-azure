variable "name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tenant_id" {
  type        = string
  default     = ""
  description = "Azure Tenant ID"
}

variable "sku_name" {
  type        = string
  default     = "standard"
  description = "SKU for Key Vault (standard or premium)"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either 'standard' or 'premium'."
  }
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable purge protection"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is enabled for the Key Vault"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
