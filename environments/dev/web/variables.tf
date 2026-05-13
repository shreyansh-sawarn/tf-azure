variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

variable "app_service_plan_name" { type = string }
variable "asp_os_type" { type = string; default = "Linux" }
variable "asp_sku_name" { type = string; default = "P1v2" }

variable "web_app_name" { type = string }
variable "function_app_name" { type = string }

variable "storage_account_name" { type = string }
variable "storage_account_access_key" { type = string; sensitive = true }

variable "app_insights_name" { type = string }

variable "log_analytics_id" { type = string }
