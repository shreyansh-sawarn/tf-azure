output "id" {
  value       = azurerm_private_endpoint.pe.id
  description = "The ID of the private endpoint"
}

output "dns_zone_id" {
  value       = local.dns_zone_id
  description = "The ID of the private DNS zone (created or existing)"
}

output "fqdn" {
  value       = azurerm_private_endpoint.pe.custom_dns_configs[0].fqdn
  description = "The FQDN of the private endpoint"
}
