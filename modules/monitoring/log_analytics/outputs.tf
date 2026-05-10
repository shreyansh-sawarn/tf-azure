output "id" {
  value       = azurerm_log_analytics_workspace.law.id
  description = "The ID of the Log Analytics Workspace"
}

output "name" {
  value       = azurerm_log_analytics_workspace.law.name
  description = "The name of the Log Analytics Workspace"
}
