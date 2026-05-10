variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be created"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the Virtual Network"
}

variable "subnets" {
  type        = map(object({ address_prefixes = list(string) }))
  description = "Map of subnets to create"
  default = {
    web                 = { address_prefixes = ["10.0.1.0/24"] }
    app                 = { address_prefixes = ["10.0.2.0/24"] }
    db                  = { address_prefixes = ["10.0.3.0/24"] }
    AzureFirewallSubnet = { address_prefixes = ["10.0.4.0/24"] }
  }
}

variable "nsg_rules" {
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  })))
  description = "Network Security Group rules for each subnet"
  default = {
    web = [
      {
        name                       = "AllowHTTPS"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowHTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    app = [
      {
        name                       = "AllowFromWebSubnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "10.0.1.0/24"
        destination_address_prefix = "*"
      }
    ]
    db = [
      {
        name                       = "AllowSQLFromAppSubnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.0.2.0/24"
        destination_address_prefix = "*"
      }
    ]
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}
