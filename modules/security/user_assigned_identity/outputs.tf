output "id" {
  value       = azurerm_user_assigned_identity.identity.id
  description = "The ID of the Managed Identity"
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.identity.principal_id
  description = "The Principal ID of the Managed Identity"
}

output "client_id" {
  value       = azurerm_user_assigned_identity.identity.client_id
  description = "The Client ID of the Managed Identity"
}

output "name" {
  value       = azurerm_user_assigned_identity.identity.name
  description = "The name of the Managed Identity"
}
