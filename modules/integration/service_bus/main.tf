resource "azurerm_servicebus_namespace" "sb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "queue" {
  name                 = var.queue_name
  namespace_id         = azurerm_servicebus_namespace.sb.id
  partitioning_enabled = true
}
