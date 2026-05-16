mock_provider "azurerm" {}

run "validate_availability_set_config" {
  command = plan

  variables {
    name                = "test-as"
    location            = "eastus"
    resource_group_name = "test-rg"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_availability_set.as.name == "test-as"
    error_message = "Availability Set name did not match"
  }
}
