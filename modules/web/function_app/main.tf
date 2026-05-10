resource "azurerm_linux_function_app" "func" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {}

  tags = var.tags
}
