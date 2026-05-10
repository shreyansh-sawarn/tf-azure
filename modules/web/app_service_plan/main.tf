resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

output "id" {
  value = azurerm_service_plan.plan.id
}

variable "app_service_plan_name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "os_type" { type = string; default = "Linux" }
variable "sku_name" { type = string; default = "B1" }
variable "tags" { type = map(string); default = {} }
