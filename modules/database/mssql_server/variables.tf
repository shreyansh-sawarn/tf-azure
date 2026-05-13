variable "name" {
  type        = string
  description = "Name of the SQL Server"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "admin_username" {
  type        = string
  default     = "sqladmin"
  description = "SQL Server admin username"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "SQL Server admin password"
  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is enabled for the SQL Server"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
