# Mock Variables definition for Compute Virtual Machine module
# Used by the AI Test Generator to write native .tftest.hcl unit assertions

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine. Should follow naming standards."
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "The SKU size of the virtual machine. Must use burstable tiers (B-series) in dev."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin username for the VM credentials."
}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "Should password login be disabled (enforces SSH keys for security compliance)."
}
