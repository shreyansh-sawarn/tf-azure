resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  site_config {
    always_on = true
  }

  tags = var.tags
}

output "default_hostname" {
  value = azurerm_linux_web_app.webapp.default_hostname
}

variable "app_service_name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "service_plan_id" { type = string }
variable "tags" { type = map(string); default = {} }
