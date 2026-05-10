output "id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "The ID of the Linux Virtual Machine"
}

output "private_ip" {
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
  description = "The private IP address of the Linux Virtual Machine"
}
