mock_provider "azurerm" {}

run "validate_web_app_config" {
  command = plan

  variables {
    app_service_name    = "test-app"
    location            = "eastus"
    resource_group_name = "test-rg"
    service_plan_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Web/serverfarms/test-asp"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_linux_web_app.webapp.name == "test-app"
    error_message = "Web App name did not match"
  }

  assert {
    condition     = azurerm_linux_web_app.webapp.https_only == true
    error_message = "HTTPS Only should be enabled"
  }
}
