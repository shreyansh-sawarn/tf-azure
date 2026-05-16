variable "resource_group_name" { 
  type = string
}

variable "location" { 
  type = string
}

variable "tags" { 
  type = map(string)
}

variable "log_analytics_name" { 
  type = string
}

variable "log_analytics_sku" {
  type = string
  default = "PerGB2018"
}
variable "log_retention_days" {
  type = number
  default = 30
}

variable "acr_name" { 
  type = string
}

variable "acr_sku" {
  type = string
  default = "Basic"
}
variable "acr_admin_enabled" {
  type = bool
  default = false
}

variable "service_bus_name" { 
  type = string
}

variable "sb_sku" {
  type = string
  default = "Standard"
}

variable "logic_app_name" { 
  type = string
}

variable "vmss_id" { 
  type = string
}
