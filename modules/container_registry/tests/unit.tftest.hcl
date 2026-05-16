mock_provider "azurerm" {}

run "validate_acr_config" {
  command = plan

  variables {
    name                = "testacr"
    location            = "eastus"
    resource_group_name = "test-rg"
    sku                 = "Premium"
    admin_enabled       = true

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_container_registry.acr.name == "testacr"
    error_message = "ACR name did not match"
  }

  assert {
    condition     = azurerm_container_registry.acr.sku == "Premium"
    error_message = "ACR SKU did not match"
  }
}
