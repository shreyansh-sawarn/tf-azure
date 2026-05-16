resource "azurerm_monitor_action_group" "main" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name

  email_receiver {
    name                    = "admin-email"
    email_address           = var.admin_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "${var.prefix}-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = var.target_resource_ids
  description         = "Action will be triggered when CPU usage is greater than 80%."
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
