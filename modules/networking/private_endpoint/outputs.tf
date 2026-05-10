output "id" {
  value       = azurerm_private_endpoint.pe.id
  description = "The ID of the private endpoint"
}

output "private_ip" {
  value       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
  description = "The private IP address of the endpoint"
}
