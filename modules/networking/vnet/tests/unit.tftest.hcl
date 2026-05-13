# Provider configuration for tests
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "00000000-0000-0000-0000-000000000000"
  tenant_id                       = "00000000-0000-0000-0000-000000000000"
  client_id                       = "00000000-0000-0000-0000-000000000000"
  client_secret                   = "dummy-secret"
}

run "validate_vnet_and_subnets" {
  command = plan

  variables {
    resource_group_name = "test-rg"
    location            = "eastus"
    vnet_name           = "test-vnet"
    address_space       = ["10.1.0.0/16"]
    subnets = {
      test-subnet = { address_prefixes = ["10.1.1.0/24"] }
    }
  }

  assert {
    condition     = azurerm_virtual_network.vnet.name == "test-vnet"
    error_message = "VNET name did not match the input variable"
  }

  assert {
    condition     = contains(azurerm_virtual_network.vnet.address_space, "10.1.0.0/16")
    error_message = "VNET address space did not match the input variable"
  }

  assert {
    condition     = length(azurerm_subnet.subnets) == 1
    error_message = "Incorrect number of subnets created"
  }
}
