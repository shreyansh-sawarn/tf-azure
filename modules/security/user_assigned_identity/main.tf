resource "azurerm_user_assigned_identity" "identity" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

output "id" {
  value = azurerm_user_assigned_identity.identity.id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.identity.principal_id
}

output "client_id" {
  value = azurerm_user_assigned_identity.identity.client_id
}
