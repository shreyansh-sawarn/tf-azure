mock_provider "azurerm" {}

run "validate_private_endpoint_config" {
  command = plan

  variables {
    name                = "test-pe"
    location            = "eastus"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/compute"
    vnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
    target_resource_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Sql/servers/test-sql"
    subresource_names   = ["sqlServer"]
    dns_zone_name       = "privatelink.database.windows.net"
    create_dns_zone     = true

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_private_endpoint.pe.name == "test-pe"
    error_message = "Private Endpoint name did not match"
  }

  assert {
    condition     = length(azurerm_private_dns_zone.zone) == 1
    error_message = "DNS zone should be created when create_dns_zone is true"
  }
}
