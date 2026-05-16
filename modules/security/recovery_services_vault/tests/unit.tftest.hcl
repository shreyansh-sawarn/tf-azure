mock_provider "azurerm" {}

run "validate_rsv_config" {
  command = plan

  variables {
    name                = "test-rsv"
    location            = "eastus"
    resource_group_name = "test-rg"
    storage_mode_type   = "GeoRedundant"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_recovery_services_vault.vault.name == "test-rsv"
    error_message = "RSV name did not match"
  }

  assert {
    condition     = azurerm_recovery_services_vault.vault.storage_mode_type == "GeoRedundant"
    error_message = "RSV storage mode did not match"
  }

  assert {
    condition     = azurerm_backup_policy_vm.policy.backup[0].frequency == "Daily"
    error_message = "Backup policy frequency did not match"
  }
}
