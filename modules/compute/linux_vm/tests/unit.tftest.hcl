mock_provider "azurerm" {}

run "validate_linux_vm_config" {
  command = plan

  variables {
    name                 = "test-vm"
    resource_group_name  = "test-rg"
    location             = "eastus"
    vm_size              = "Standard_DS1_v2"
    admin_username       = "adminuser"
    admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzR9hL7WzY4f3pZ8Q6f5J2/rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9rQkX1v5lX8Z9 test@example.com"
    subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.name == "test-vm"
    error_message = "VM name did not match"
  }

  assert {
    condition     = azurerm_linux_virtual_machine.vm.size == "Standard_DS1_v2"
    error_message = "VM size did not match"
  }

  assert {
    condition     = azurerm_network_interface.nic.name == "test-vm-nic"
    error_message = "NIC name did not match the expected pattern"
  }
}
