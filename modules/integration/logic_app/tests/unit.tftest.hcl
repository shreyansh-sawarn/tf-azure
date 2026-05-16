mock_provider "azurerm" {}

run "validate_logic_app_config" {
  command = plan

  variables {
    name                = "test-logic"
    location            = "eastus"
    resource_group_name = "test-rg"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_logic_app_workflow.logic.name == "test-logic"
    error_message = "Logic App name did not match"
  }
}
