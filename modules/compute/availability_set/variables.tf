variable "name" {
  type        = string
  description = "Name of the availability set"
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
  description = "Tags for the resources"
}
