variable "name" {
  type        = string
  description = "Name of the private endpoint"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for the private endpoint"
}

variable "vnet_id" {
  type        = string
  description = "ID of the virtual network for DNS linking"
}

variable "target_resource_id" {
  type        = string
  description = "ID of the resource to connect to"
}

variable "subresource_names" {
  type        = list(string)
  description = "List of subresource names (e.g., ['blob'] or ['sqlServer'])"
}

variable "dns_zone_name" {
  type        = string
  description = "Name of the private DNS zone"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
