variable "name" {
  type        = string
  description = "Name of the diagnostic setting"
}

variable "target_resource_id" {
  type        = string
  description = "ID of the resource to monitor"
}

variable "workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace"
}

variable "log_categories" {
  type        = list(string)
  default     = []
  description = "List of log categories to enable"
}

variable "metric_categories" {
  type        = list(string)
  default     = ["AllMetrics"]
  description = "List of metric categories to enable"
}
