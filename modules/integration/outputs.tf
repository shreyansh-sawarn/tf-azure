output "servicebus_id" {
  value = azurerm_servicebus_namespace.sb.id
}

output "logic_app_id" {
  value = azurerm_logic_app_workflow.logic.id
}
