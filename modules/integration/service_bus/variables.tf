variable "name" {
  type        = string
  description = "Name of the Service Bus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "SKU for Service Bus"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of 'Basic', 'Standard', or 'Premium'."
  }
}

variable "queue_name" {
  type        = string
  description = "Name of the queue"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
