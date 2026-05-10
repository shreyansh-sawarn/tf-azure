resource "azurerm_servicebus_namespace" "sb" {
  name                = var.service_bus_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_servicebus_queue" "queue" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.sb.id

  enable_partitioning = true
}

resource "azurerm_logic_app_workflow" "logic" {
  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}
