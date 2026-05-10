output "instrumentation_key" {
  value       = azurerm_application_insights.insights.instrumentation_key
  sensitive   = true
  description = "The instrumentation key of the application insights"
}
