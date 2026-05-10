variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "account_tier" {
  description = "Tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  type        = string
  default     = "GRS" # High Availability default
}

variable "containers" {
  description = "List of containers to create"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for the storage account"
  type        = map(string)
  default     = {}
}
