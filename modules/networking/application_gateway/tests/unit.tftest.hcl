mock_provider "azurerm" {}

run "validate_app_gateway_config" {
  command = plan

  variables {
    name                = "test-agw"
    location            = "eastus"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/AppGatewaySubnet"

    waf_enabled = true
    waf_mode    = "Prevention"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_application_gateway.agw.name == "test-agw"
    error_message = "App Gateway name did not match"
  }

  assert {
    condition     = azurerm_application_gateway.agw.waf_configuration[0].firewall_mode == "Prevention"
    error_message = "WAF should be in Prevention mode"
  }

  assert {
    condition     = azurerm_application_gateway.agw.sku[0].tier == "WAF_v2"
    error_message = "App Gateway SKU tier did not match"
  }
}
