output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "sql_server_fqdn" {
  value = module.database.sql_server_fqdn
}

output "key_vault_uri" {
  value = module.security.key_vault_uri
}

output "vm_private_ip" {
  value = module.compute.vm_private_ip
}

output "webapp_url" {
  value = module.web.webapp_url
}

output "function_app_url" {
  value = module.web.function_app_url
}

output "servicebus_id" {
  value = module.integration.servicebus_id
}
