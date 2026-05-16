mock_provider "azurerm" {}

run "validate_route_table_config" {
  command = plan

  variables {
    name                = "test-rt"
    location            = "eastus"
    resource_group_name = "test-rg"
    subnet_ids          = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"]
    
    routes = [
      {
        name           = "test-route"
        address_prefix = "0.0.0.0/0"
        next_hop_type  = "VirtualAppliance"
        next_hop_ip    = "10.0.1.4"
      }
    ]

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_route_table.rt.name == "test-rt"
    error_message = "Route Table name did not match"
  }

  assert {
    condition     = length(azurerm_route_table.rt.route) == 1
    error_message = "Route count did not match"
  }
}
