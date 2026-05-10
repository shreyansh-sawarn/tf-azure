variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sql_db_name" {
  description = "Name of the SQL Database"
  type        = string
}

variable "admin_username" {
  description = "SQL Server admin username"
  type        = string
  default     = "sqladmin"
}

variable "admin_password" {
  description = "SQL Server admin password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU for the database (e.g., S0, Basic, GP_Gen5_2)"
  type        = string
  default     = "S0"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
