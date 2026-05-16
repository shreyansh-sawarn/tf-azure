resource "azurerm_recovery_services_vault" "vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  storage_mode_type   = var.storage_mode_type # GeoRedundant or LocallyRedundant
  soft_delete_enabled = true
  tags                = var.tags
}

resource "azurerm_backup_policy_vm" "policy" {
  name                = "${var.name}-vm-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }
}

output "vault_id" {
  value = azurerm_recovery_services_vault.vault.id
}

output "policy_id" {
  value = azurerm_backup_policy_vm.policy.id
}
