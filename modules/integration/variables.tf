variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "service_bus_name" {
  description = "Name of the Service Bus Namespace"
  type        = string
}

variable "queue_name" {
  description = "Name of the Service Bus Queue"
  type        = string
}

variable "logic_app_name" {
  description = "Name of the Logic App"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
