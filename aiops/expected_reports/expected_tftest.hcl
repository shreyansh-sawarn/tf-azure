# AI-Generated Unit Test block for Virtual Machine module variables
# Generated on: 2026-05-23T18:40:00Z

mock_provider "azurerm" {}

variables {
  vm_name                         = "test-vm"
  vm_size                         = "Standard_B2s"
  admin_username                  = "azureuser"
  disable_password_authentication = true
}

run "validate_vm_size" {
  command = plan

  assert {
    condition     = var.vm_size == "Standard_B2s" || var.vm_size == "Standard_B1s"
    error_message = "Oversized VM SKU declared. Must use burstable Standard_B-series sizes for non-production."
  }
}

run "validate_ssh_authentication" {
  command = plan

  assert {
    condition     = var.disable_password_authentication == true
    error_message = "VM security policy violation: password authentication must be disabled. Enforce SSH key login."
  }
}
