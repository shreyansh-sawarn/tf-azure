output "web_app_hostname" {
  value       = module.web_app.default_hostname
  description = "The default hostname of the Web App"
}

output "sql_server_fqdn" {
  value       = module.sql_server.server_fqdn
  description = "The fully qualified domain name of the SQL Server"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the deployed resource group"
}
