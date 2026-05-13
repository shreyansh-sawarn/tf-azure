data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = true
  tenant_id                     = var.tenant_id != "" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = var.purge_protection_enabled
  enable_rbac_authorization     = true
  sku_name                      = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
