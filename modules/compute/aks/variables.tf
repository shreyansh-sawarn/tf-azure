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
  type    = map(string)
  default = {}
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

variable "log_analytics_workspace_id" { 
  type = string
}

variable "acr_id" { 
  type    = string
  default = null
}

variable "service_cidr" { 
  type    = string
  default = "10.2.0.0/16"
}

variable "dns_service_ip" { 
  type    = string
  default = "10.2.0.10"
}
