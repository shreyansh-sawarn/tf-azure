provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "00000000-0000-0000-0000-000000000000"
  tenant_id                       = "00000000-0000-0000-0000-000000000000"
  client_id                       = "00000000-0000-0000-0000-000000000000"
  client_secret                   = "dummy-secret"
}

run "validate_rg_name" {
  command = plan

  variables {
    resource_group_name = "test-rg"
    location            = "eastus"
    tags = {
      Environment = "test"
    }
  }

  assert {
    condition     = azurerm_resource_group.rg.name == "test-rg"
    error_message = "Resource group name did not match the input variable"
  }

  assert {
    condition     = azurerm_resource_group.rg.location == "eastus"
    error_message = "Resource group location did not match the input variable"
  }
}
