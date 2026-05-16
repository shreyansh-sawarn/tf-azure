variable "name" {
  type        = string
  description = "Name of the route table"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs to associate with this route table"
}

variable "routes" {
  type = list(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
    next_hop_ip    = optional(string)
  }))
  default     = []
  description = "List of custom routes"
}
