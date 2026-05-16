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
    admin_ssh_key_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD36I5TOn6oX/auxlLXlJH7UzZ4X3hByb9Vt+xTREu7VT3YXDuaN+3zmejU7Y/V/VIZia5X2Ezw7J7+YLLXSEtR5gVMs6eXJanUMcSyu0reia3xZw2uIfhbQgEtkNK83fjAZoq3WzRccy4omYZ9ii7J9bz14I4WeDF5O0CookeAMX5ZXTPkOrd3OjI2d/8lV3fbK2/ozcLydx3BzTfIDbCH16JBJzfa+8/+tQepYVmSEqQCUq73V40eQ+8DSxvAd2FId9VUnejheLUaPsl2Ou2CUDL2OrpdUPOWvjAh3/2slUJyynhIvJkrIUagFaNViqa9kavSd90yIuzG4IdwMoa5 test@example.com"
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
