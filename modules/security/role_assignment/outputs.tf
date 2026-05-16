output "id" {
  value       = azurerm_role_assignment.role.id
  description = "The ID of the Role Assignment"
}

output "principal_id" {
  value       = var.principal_id
  description = "The Principal ID assigned to the role"
}
