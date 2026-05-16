variable "name" { 
  type = string
}

variable "location" { 
  type = string
}

variable "resource_group_name" { 
  type = string
}

variable "tags" {
  type = map(string)
  default = {
}
}

variable "type" {
  type        = string
  description = "Type of load balancer: Public or Internal"
  default     = "Public"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Required if type is Internal"
}

variable "probe_port" {
  type    = number
  default = 80
}

variable "probe_protocol" {
  type    = string
  default = "Http"
}

variable "frontend_port" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 80
}
