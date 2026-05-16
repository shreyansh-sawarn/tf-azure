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
    admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8zf9vHSA7OtQwWnexPIq8pSfrcb4L4/3jLb6sAF39oxJa/tLCtADt9WfcOt72a6MSukfXZYaXE0RD1NdlHyQ5wigk2k+WOEg+HxXjNpXU5jnx3OVTjWrV0GwVZcMCurYUrYFQ+1aJk92X2q28XBuImgtSu3yKI6+Llthou0PONyvhrvaLs+DpaAy0mOGLbu++gYg+SSLZaUJnRtb5dv6Ju03quA1lRBJHKU1auhNGtN5YkXQQJwEPg== test@example.com"
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
