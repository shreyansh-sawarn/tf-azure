variable "name" {
  type        = string
  description = "Name of the Application Gateway"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "ID of the dedicated Application Gateway subnet"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the resources"
}

variable "sku_name" {
  type    = string
  default = "WAF_v2"
}

variable "sku_tier" {
  type    = string
  default = "WAF_v2"
}

variable "capacity" {
  type    = number
  default = 2
}

variable "backend_pool_name" {
  type    = string
  default = "default-backend-pool"
}

variable "waf_enabled" {
  type    = bool
  default = true
}

variable "waf_mode" {
  type    = string
  default = "Prevention"
  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "waf_mode must be 'Detection' or 'Prevention'."
  }
}

variable "waf_rule_set_version" {
  type    = string
  default = "3.2"
}
