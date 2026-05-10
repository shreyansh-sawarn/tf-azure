variable "name" {
  type        = string
  description = "Name of the application insights"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "application_type" {
  type        = string
  default     = "web"
  description = "Type of application"
}

variable "workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}
