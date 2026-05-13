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
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}

# Firewall variables (simplified for stack orchestration)
variable "firewall_name" {
  type        = string
  description = "Name of the Azure Firewall"
}

variable "firewall_sku_name" {
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  type        = string
  default     = "Standard"
}
