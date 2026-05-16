mock_provider "azurerm" {}

run "validate_load_balancer_config" {
  command = plan

  variables {
    name                = "test-lb"
    location            = "eastus"
    resource_group_name = "test-rg"
    type                = "Internal"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_lb.lb.sku == "Standard"
    error_message = "LB SKU did not match"
  }

  assert {
    condition     = azurerm_lb.lb.frontend_ip_configuration[0].subnet_id != null
    error_message = "Internal LB should have a subnet_id"
  }

  assert {
    condition     = length(azurerm_public_ip.lb_pip) == 0
    error_message = "Internal LB should not have a Public IP"
  }
}
