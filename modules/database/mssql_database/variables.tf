variable "name" {
  type        = string
  description = "Name of the SQL Database"
}

variable "server_id" {
  type        = string
  description = "ID of the SQL Server"
}

variable "max_size_gb" {
  type        = number
  default     = 2
  description = "Maximum size of the database in GB"
}

variable "sku_name" {
  type        = string
  default     = "S0"
  description = "SKU for the database"
  validation {
    condition     = contains(["Basic", "S0", "S1", "S2", "P1", "P2", "GP_Gen5_2"], var.sku_name)
    error_message = "sku_name must be a valid Azure SQL Database SKU (Basic, S0, S1, S2, P1, P2, GP_Gen5_2)."
  }
}

variable "zone_redundant" {
  type        = bool
  default     = false
  description = "Whether to enable zone redundancy"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
