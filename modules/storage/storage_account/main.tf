resource "azurerm_storage_account" "storage" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.containers)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

output "id" { value = azurerm_storage_account.storage.id }
output "name" { value = azurerm_storage_account.storage.name }
output "primary_access_key" { value = azurerm_storage_account.storage.primary_access_key; sensitive = true }
output "primary_blob_endpoint" { value = azurerm_storage_account.storage.primary_blob_endpoint }

variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "account_tier" { type = string; default = "Standard" }
variable "replication_type" { type = string; default = "GRS" }
variable "containers" { type = list(string); default = [] }
variable "tags" { type = map(string); default = {} }
