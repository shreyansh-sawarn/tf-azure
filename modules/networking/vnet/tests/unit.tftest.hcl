mock_provider "azurerm" {}

run "validate_vnet_and_subnets" {
  command = plan

  variables {
    resource_group_name = "test-rg"
    location            = "eastus"
    vnet_name           = "test-vnet"
    address_space       = ["10.1.0.0/16"]
    subnets             = { test-subnet = { address_prefixes = ["10.1.1.0/24"] } }
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

# Apply-mode test: exercises computed outputs (subnet IDs, vnet ID) that only
# resolve to concrete mock values after apply, not just at plan time.
run "apply_creates_vnet_and_outputs" {
  command = apply

  variables {
    resource_group_name = "test-rg"
    location            = "eastus"
    vnet_name           = "test-vnet"
    address_space       = ["10.1.0.0/16"]
    subnets             = { test-subnet = { address_prefixes = ["10.1.1.0/24"] } }
  }

  assert {
    condition     = output.vnet_id != null
    error_message = "vnet_id output should be populated after apply"
  }

  assert {
    condition     = output.subnet_ids["test-subnet"] != null
    error_message = "subnet_ids output should contain the test-subnet ID after apply"
  }
}
