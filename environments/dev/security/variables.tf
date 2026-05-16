variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "key_vault_name" {
  type = string
}

variable "kv_sku_name" {
  type    = string
  default = "standard"
}
variable "kv_public_network_access" {
  type    = bool
  default = false
}

variable "storage_account_id" {
  type = string
}

variable "log_analytics_id" {
  type = string
}
