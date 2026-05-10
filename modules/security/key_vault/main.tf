data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id != "" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = var.sku_name

  access_policy {
    tenant_id = var.tenant_id != "" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions    = ["Get", "List", "Create", "Delete", "Update"]
    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  tags = var.tags
}

output "id" { value = azurerm_key_vault.vault.id }
output "vault_uri" { value = azurerm_key_vault.vault.vault_uri }

variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tenant_id" { type = string; default = "" }
variable "sku_name" { type = string; default = "standard" }
variable "tags" { type = map(string); default = {} }
