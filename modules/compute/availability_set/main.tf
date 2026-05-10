resource "azurerm_availability_set" "avset" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  managed             = true
  tags                = var.tags
}
