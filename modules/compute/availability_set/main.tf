resource "azurerm_availability_set" "avset" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  managed             = true
  tags                = var.tags
}

output "id" { value = azurerm_availability_set.avset.id }

variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string); default = {} }
