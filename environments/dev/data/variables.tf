variable "resource_group_name" { 
  type = string
}

variable "location" { 
  type = string
}

variable "tags" { 
  type = map(string)
}

# SQL
variable "sql_server_name" { 
  type = string
}

variable "sql_db_name" { 
  type = string
}

variable "sql_admin_username" { 
  type = string
}

variable "sql_admin_password" { 
  type = string
}

variable "sql_db_sku" {
  type = string
  default = "Basic"
}
variable "sql_public_network_access" {
  type = bool
  default = false
}

# Storage
variable "storage_account_name" { 
  type = string
}

variable "storage_tier" {
  type = string
  default = "Standard"
}
variable "storage_replication" {
  type = string
  default = "LRS"
}
variable "storage_public_network_access" {
  type = bool
  default = false
}
variable "storage_containers" {
  type = list(string)
  default = []
}
