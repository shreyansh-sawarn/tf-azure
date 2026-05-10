variable "name" {
  type        = string
  description = "Name of the Container Registry"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be created"
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The sku must be one of Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "Should the admin user be enabled?"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the resource"
}
