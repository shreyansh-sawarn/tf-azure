data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id != "00000000-0000-0000-0000-000000000000" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = var.sku_name

  access_policy {
    tenant_id = var.tenant_id != "00000000-0000-0000-0000-000000000000" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    storage_permissions = [
      "Get", "List"
    ]
  }

  tags = var.tags
}
