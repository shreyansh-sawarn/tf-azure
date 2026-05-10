output "webapp_url" {
  value = azurerm_linux_web_app.webapp.default_hostname
}

output "function_app_url" {
  value = azurerm_linux_function_app.func.default_hostname
}

output "app_insights_instrumentation_key" {
  value     = azurerm_application_insights.insights.instrumentation_key
  sensitive = true
}
