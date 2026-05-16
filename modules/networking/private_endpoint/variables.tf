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

variable "create_dns_zone" {
  type        = bool
  default     = true
  description = "Whether to create a new private DNS zone or use an existing one"
}

variable "existing_dns_zone_id" {
  type        = string
  default     = null
  description = "ID of an existing private DNS zone (used when create_dns_zone = false)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
