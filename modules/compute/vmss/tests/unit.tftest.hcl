mock_provider "azurerm" {}

run "validate_vmss_config" {
  command = plan

  variables {
    name                 = "test-vmss"
    resource_group_name  = "test-rg"
    location             = "eastus"
    sku                  = "Standard_B1s"
    instances            = 2
    admin_username       = "azureuser"
    admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyZMOnA7PZ/m3NPeAY6rsh884iE45T+r8/64uUWCY1410t6T+p9OqL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV9qL7Q8C4q9+N/rV test@example.com"
    subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"

    custom_data = "IyEvYmluL2Jhc2gKYXB0LWdldCB1cGRhdGUK" # base64 placeholder

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss.name == "test-vmss"
    error_message = "VMSS name did not match"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss.sku == "Standard_B1s"
    error_message = "VMSS SKU did not match"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss.instances == 2
    error_message = "VMSS instance count did not match"
  }
}
