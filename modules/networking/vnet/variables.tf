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
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
  description = "Map of subnets to create, with optional service endpoints"
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
  description = "Network Security Group rules for each subnet. Defaults to none: this module does not ship a permissive network default, so no NSGs are created unless you explicitly pass rules. See this module's README for a reference 3-tier (web/app/db) rule set to copy and adapt."
  default     = {}
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "ID of an existing DDoS Protection Plan. Set to null to disable."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}
