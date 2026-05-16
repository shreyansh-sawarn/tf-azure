mock_provider "azurerm" {}

run "validate_function_app_config" {
  command = plan

  variables {
    function_app_name          = "test-func"
    location                   = "eastus"
    resource_group_name        = "test-rg"
    service_plan_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Web/serverfarms/test-asp"
    storage_account_name       = "teststorage"
    storage_account_access_key = "dummy-key"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_linux_function_app.func.name == "test-func"
    error_message = "Function App name did not match"
  }
}
