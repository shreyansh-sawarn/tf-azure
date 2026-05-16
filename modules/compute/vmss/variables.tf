variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string); default = {} }

variable "sku" {
  type    = string
  default = "Standard_B1s"
}

variable "instances" {
  type    = number
  default = 2
}

variable "min_instances" {
  type    = number
  default = 1
}

variable "max_instances" {
  type    = number
  default = 5
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_ssh_key_public" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "backend_address_pool_ids" {
  type    = list(string)
  default = []
}

variable "identity_ids" {
  type    = list(string)
  default = []
  description = "List of User Assigned Identity IDs"
}

variable "custom_data" {
  type        = string
  default     = null
  description = "Custom data to pass to the VMSS instances (e.g. cloud-init script)"
}
