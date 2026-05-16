mock_provider "azurerm" {}

run "validate_alerts_config" {
  command = plan

  variables {
    resource_group_name = "test-rg"
    action_group_name   = "test-action-group"
    short_name          = "testalerts"
    admin_email         = "test@example.com"
    prefix              = "test"
    target_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Compute/virtualMachineScaleSets/test-vmss"]
  }

  assert {
    condition     = azurerm_monitor_action_group.main.name == "test-action-group"
    error_message = "Action Group name did not match"
  }

  assert {
    condition     = azurerm_monitor_metric_alert.cpu_alert.name == "test-cpu-alert"
    error_message = "Metric Alert name did not match"
  }
}
