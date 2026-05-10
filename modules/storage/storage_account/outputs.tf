output "id" {
  value       = azurerm_storage_account.storage.id
  description = "The ID of the storage account"
}

output "name" {
  value       = azurerm_storage_account.storage.name
  description = "The name of the storage account"
}

output "primary_access_key" {
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account"
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.storage.primary_blob_endpoint
  description = "The primary blob endpoint"
}
