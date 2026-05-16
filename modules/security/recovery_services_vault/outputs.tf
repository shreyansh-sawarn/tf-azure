output "vault_name" {
  value       = azurerm_recovery_services_vault.vault.name
  description = "The name of the Recovery Services Vault"
}

output "policy_name" {
  value       = azurerm_backup_policy_vm.policy.name
  description = "The name of the VM backup policy"
}
