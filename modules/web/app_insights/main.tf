resource "azurerm_application_insights" "insights" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type

  tags = var.tags
}

output "instrumentation_key" {
  value     = azurerm_application_insights.insights.instrumentation_key
  sensitive = true
}

variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "application_type" { type = string; default = "web" }
variable "tags" { type = map(string); default = {} }
