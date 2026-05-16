variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}

variable "node_count" {
  type    = number
  default = 2
}
variable "node_size" {
  type    = string
  default = "Standard_DS2_v2"
}
variable "subnet_id" {
  type = string
}

variable "enable_auto_scaling" {
  type    = bool
  default = true
}
variable "min_node_count" {
  type    = number
  default = 1
}
variable "max_node_count" {
  type    = number
  default = 3
}

variable "log_analytics_id" {
  type = string
}

variable "acr_id" {
  type = string
}
