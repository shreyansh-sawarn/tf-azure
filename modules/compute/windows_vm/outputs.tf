output "id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "The ID of the Windows Virtual Machine"
}

output "private_ip" {
  value       = azurerm_windows_virtual_machine.vm.private_ip_address
  description = "The private IP address of the Windows Virtual Machine"
}
