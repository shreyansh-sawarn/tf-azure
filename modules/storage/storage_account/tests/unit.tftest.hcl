provider "azurerm" {
  features {}
  skip_provider_registration = true
}

run "validate_storage_account_config" {
  command = plan

  variables {
    name                          = "testsa"
    resource_group_name           = "test-rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    replication_type              = "LRS"
    public_network_access_enabled = false
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_storage_account.storage.name == "testsa"
    error_message = "Storage account name did not match"
  }

  assert {
    condition     = azurerm_storage_account.storage.min_tls_version == "TLS1_2"
    error_message = "Storage account must use TLS 1.2"
  }

  assert {
    condition     = azurerm_storage_account.storage.public_network_access_enabled == false
    error_message = "Public network access should be disabled"
  }
}
