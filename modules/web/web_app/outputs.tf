output "default_hostname" {
  value       = azurerm_linux_web_app.webapp.default_hostname
  description = "The default hostname of the web app"
}
