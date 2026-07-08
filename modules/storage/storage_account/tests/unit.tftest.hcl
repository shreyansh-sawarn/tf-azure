mock_provider "azurerm" {}

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

run "reject_invalid_account_tier" {
  command = plan

  variables {
    name                          = "testsa"
    resource_group_name           = "test-rg"
    location                      = "eastus"
    account_tier                  = "Ultra" # not a valid Azure storage account tier
    replication_type              = "LRS"
    public_network_access_enabled = false
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  expect_failures = [
    var.account_tier,
  ]
}
