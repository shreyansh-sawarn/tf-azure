variable "resource_group_name" { 
  type = string
}

variable "location" { 
  type = string
}

variable "tags" { 
  type = map(string)
}

variable "subnet_id" { 
  type = string
}

variable "availability_set_name" { 
  type = string
}

variable "linux_vm_name" { 
  type = string
}

variable "linux_vm_size" {
  type = string
  default = "Standard_B1s"
}

variable "windows_vm_name" { 
  type = string
}

variable "windows_vm_size" {
  type = string
  default = "Standard_B2s"
}

variable "lb_name" {
  type        = string
  description = "Name of the internal load balancer"
}

variable "key_vault_id" { 
  type = string
}

variable "admin_username" {
  type = string
  default = "azureuser"
}
variable "admin_password" {
  type = string
  sensitive = true
}
variable "admin_ssh_key_public" {
  type = string
  default = null
}
