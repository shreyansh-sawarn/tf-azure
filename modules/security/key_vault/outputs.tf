output "id" {
  value       = azurerm_key_vault.vault.id
  description = "The ID of the Key Vault"
}

output "vault_uri" {
  value       = azurerm_key_vault.vault.vault_uri
  description = "The URI of the Key Vault"
}
