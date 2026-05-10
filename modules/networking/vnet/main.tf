resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

output "vnet_id" { value = azurerm_virtual_network.vnet.id }
output "vnet_name" { value = azurerm_virtual_network.vnet.name }
output "subnet_ids" { value = { for k, v in azurerm_subnet.subnets : k => v.id } }

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string); default = ["10.0.0.0/16"] }
variable "subnets" {
  type = map(object({ address_prefixes = list(string) }))
  default = {
    web = { address_prefixes = ["10.0.1.0/24"] }
    app = { address_prefixes = ["10.0.2.0/24"] }
    db  = { address_prefixes = ["10.0.3.0/24"] }
  }
}
variable "tags" { type = map(string); default = {} }
