module "key_vault" {
  source = "../../../modules/security/key_vault"

  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.kv_sku_name
  public_network_access_enabled = var.kv_public_network_access
  tags                          = var.tags
}

# Example of grouping diagnostic settings in the security stack
module "diag_storage" {
  source = "../../../modules/monitoring/diagnostic_setting"

  name               = "diag-storage"
  target_resource_id = var.storage_account_id
  workspace_id       = var.log_analytics_id
}

module "diag_keyvault" {
  source = "../../../modules/monitoring/diagnostic_setting"

  name               = "diag-keyvault"
  target_resource_id = module.key_vault.id
  workspace_id       = var.log_analytics_id
}

module "recovery_vault" {
  source = "../../../modules/security/recovery_services_vault"

  name                = var.recovery_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  storage_mode_type   = "GeoRedundant"
  tags                = var.tags
}

output "key_vault_id" {

  value = module.key_vault.id
}

output "key_vault_uri" {
  value = module.key_vault.vault_uri
}
