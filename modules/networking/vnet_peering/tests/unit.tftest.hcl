mock_provider "azurerm" {}

run "validate_peering_config" {
  command = plan

  variables {
    source_vnet_name           = "vnet-a"
    source_vnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/vnet-a"
    source_resource_group_name = "test-rg"

    target_vnet_name           = "vnet-b"
    target_vnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/vnet-b"
    target_resource_group_name = "test-rg"

    allow_forwarded_traffic = true
  }

  assert {
    condition     = azurerm_virtual_network_peering.source_to_target.name == "vnet-a-to-vnet-b"
    error_message = "Peering name did not match"
  }
}
