resource "azurerm_logic_app_workflow" "logic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

output "id" { value = azurerm_logic_app_workflow.logic.id }

variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string); default = {} }
