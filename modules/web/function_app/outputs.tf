output "default_hostname" {
  value       = azurerm_linux_function_app.func.default_hostname
  description = "The default hostname of the function app"
}
