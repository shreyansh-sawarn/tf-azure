variable "name" {
  type        = string
  description = "Name of the Linux Virtual Machine"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be created"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet where the Network Interface should be created"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "The SKU which should be used for this Virtual Machine"
  validation {
    condition     = contains(["Standard_B1s", "Standard_B2s", "Standard_D2s_v3", "Standard_DS1_v2"], var.vm_size)
    error_message = "The vm_size must be a valid Azure VM size (Standard_B1s, Standard_B2s, Standard_D2s_v3, Standard_DS1_v2)."
  }
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "The username of the local administrator used for the Virtual Machine"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  default     = null
  description = "The Password which should be used for the local-administrator on this Virtual Machine. Required if disable_password_authentication is false."
}

variable "admin_ssh_key_public" {
  type        = string
  default     = null
  description = "The public SSH key for the local administrator. Required if disable_password_authentication is true."
}

variable "availability_set_id" {
  type        = string
  default     = null
  description = "The ID of the Availability Set in which the Virtual Machine should be exist"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}
