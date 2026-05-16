mock_provider "azurerm" {}

run "validate_app_insights_config" {
  command = plan

  variables {
    name                = "test-ai"
    location            = "eastus"
    resource_group_name = "test-rg"
    application_type    = "web"
    workspace_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_application_insights.insights.name == "test-ai"
    error_message = "App Insights name did not match"
  }

  assert {
    condition     = azurerm_application_insights.insights.application_type == "web"
    error_message = "Application type did not match"
  }
}
