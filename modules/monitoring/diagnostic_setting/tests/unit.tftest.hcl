mock_provider "azurerm" {}

run "validate_diag_config" {
  command = plan

  variables {
    name                       = "test-diag"
    target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv"
    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"
  }

  assert {
    condition     = azurerm_monitor_diagnostic_setting.diag.name == "test-diag"
    error_message = "Diagnostic setting name did not match"
  }
}
