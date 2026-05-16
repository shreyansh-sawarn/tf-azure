variable "name" {
  type        = string
  description = "Name of the Azure Firewall"
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet where the Firewall should be deployed"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}

variable "sku_name" {
  type        = string
  default     = "AZFW_VNet"
  description = "SKU name of the Firewall. Possible values are AZFW_VNet and AZFW_Hub."
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "SKU tier of the Firewall. Possible values are Standard and Premium."
}
