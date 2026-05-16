mock_provider "azurerm" {}

run "validate_windows_vm_config" {
  command = plan

  variables {
    name                = "test-win"
    location            = "eastus"
    resource_group_name = "test-rg"
    vm_size             = "Standard_B2s"
    admin_username      = "azureuser"
    admin_password      = "P@ssw0rd1234!"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_windows_virtual_machine.vm.name == "test-win"
    error_message = "VM name did not match"
  }
}
