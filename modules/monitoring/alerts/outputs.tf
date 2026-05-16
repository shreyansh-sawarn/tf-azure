output "action_group_id" {
  value       = azurerm_monitor_action_group.main.id
  description = "The ID of the Action Group"
}

output "cpu_alert_id" {
  value       = azurerm_monitor_metric_alert.cpu_alert.id
  description = "The ID of the CPU Metric Alert"
}
