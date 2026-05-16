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

variable "storage_mode_type" {
  type        = string
  default     = "LocallyRedundant"
  description = "The storage type of the vault. Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant."
}
