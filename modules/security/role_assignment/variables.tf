variable "scope" {
  type        = string
  description = "The scope at which the Role Assignment applies (e.g. resource ID, RG ID)"
}

variable "role_definition_name" {
  type        = string
  description = "The name of a built-in Role (e.g. Reader, Contributor, Key Vault Secrets Officer)"
}

variable "principal_id" {
  type        = string
  description = "The Principal ID of the Identity to assign the role to"
}
