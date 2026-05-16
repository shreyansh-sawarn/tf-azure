output "id" {
  value       = azurerm_application_gateway.agw.id
  description = "The ID of the Application Gateway"
}

output "public_ip" {
  value       = azurerm_public_ip.agw_pip.ip_address
  description = "The public IP address of the Application Gateway"
}
