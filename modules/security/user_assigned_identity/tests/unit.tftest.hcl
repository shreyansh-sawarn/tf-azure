mock_provider "azurerm" {}

run "validate_identity_config" {
  command = plan

  variables {
    name                = "test-identity"
    location            = "eastus"
    resource_group_name = "test-rg"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_user_assigned_identity.identity.name == "test-identity"
    error_message = "Identity name did not match"
  }
}
