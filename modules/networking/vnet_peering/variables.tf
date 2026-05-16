variable "source_vnet_name" {
  type        = string
  description = "Name of the source virtual network"
}

variable "source_vnet_id" {
  type        = string
  description = "ID of the source virtual network"
}

variable "source_resource_group_name" {
  type        = string
  description = "Name of the source resource group"
}

variable "target_vnet_name" {
  type        = string
  description = "Name of the target virtual network"
}

variable "target_vnet_id" {
  type        = string
  description = "ID of the target virtual network"
}

variable "target_resource_group_name" {
  type        = string
  description = "Name of the target resource group"
}

variable "allow_forwarded_traffic" {
  type        = bool
  default     = true
  description = "Allow forwarded traffic between peered VNets (enables hub firewall routing)"
}

variable "allow_gateway_transit" {
  type        = bool
  default     = false
  description = "Allow gateway transit (hub VNet shares its VPN/ExpressRoute gateway)"
}

variable "use_remote_gateways" {
  type        = bool
  default     = false
  description = "Use the remote VNet's gateway (spoke uses hub's gateway)"
}
