mock_provider "azurerm" {}

run "validate_linux_vm_config" {
  command = plan

  variables {
    name                 = "test-vm"
    resource_group_name  = "test-rg"
    location             = "eastus"
    vm_size              = "Standard_DS1_v2"
    admin_username       = "azureuser"
    admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8zf9vHSA7OtQwWnexPIq8pSfrcb4L4/3jLb6sAF39oxJa/tLCtADt9WfcOt72a6MSukfXZYaXE0RD1NdlHyQ5wigk2k+WOEg+HxXjNpXU5jnx3OVTjWrV0GwVZcMCurYUrYFQ+1aJk92X2q28XBuImgtSu3yKI6+Llthou0PONyvhrvaLs+DpaAy0mOGLbu++gYg+SSLZaUJnRtb5dv6Ju03quA1lRBJHKU1auhNGtN5YkXQQJwEPg== test@example.com"
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
