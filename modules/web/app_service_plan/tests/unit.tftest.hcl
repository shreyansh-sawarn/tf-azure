mock_provider "azurerm" {}

run "validate_app_service_plan_config" {
  command = plan

  variables {
    app_service_plan_name = "test-asp"
    location              = "eastus"
    resource_group_name   = "test-rg"
    os_type               = "Linux"
    sku_name              = "P2v2"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_service_plan.asp.name == "test-asp"
    error_message = "App Service Plan name did not match"
  }

  assert {
    condition     = azurerm_service_plan.asp.sku_name == "P2v2"
    error_message = "SKU name did not match"
  }
}
