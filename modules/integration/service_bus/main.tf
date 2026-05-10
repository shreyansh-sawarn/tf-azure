resource "azurerm_servicebus_namespace" "sb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_servicebus_queue" "queue" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.sb.id
  enable_partitioning = true
}

output "id" { value = azurerm_servicebus_namespace.sb.id }

variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sku" { type = string; default = "Standard" }
variable "queue_name" { type = string }
variable "tags" { type = map(string); default = {} }
