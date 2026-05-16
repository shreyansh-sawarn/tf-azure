mock_provider "azurerm" {}

run "validate_firewall_config" {
  command = plan

  variables {
    name                = "test-fw"
    location            = "eastus"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AzureFirewallSubnet"
    sku_name            = "AZFW_VNet"
    sku_tier            = "Premium"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_firewall.fw.name == "test-fw"
    error_message = "Firewall name did not match"
  }

  assert {
    condition     = azurerm_firewall.fw.sku_tier == "Premium"
    error_message = "Firewall SKU tier should be Premium"
  }
}
