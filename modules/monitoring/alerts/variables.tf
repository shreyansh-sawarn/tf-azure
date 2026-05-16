variable "resource_group_name" {
  type = string
}

variable "action_group_name" {
  type = string
}

variable "short_name" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "prefix" {
  type = string
}

variable "target_resource_ids" {
  type = list(string)
}
