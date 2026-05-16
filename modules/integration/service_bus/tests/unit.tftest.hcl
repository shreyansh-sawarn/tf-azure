mock_provider "azurerm" {}

run "validate_service_bus_config" {
  command = plan

  variables {
    name                = "test-servicebus"
    location            = "eastus"
    resource_group_name = "test-rg"
    sku                 = "Standard"
    queue_name          = "test-queue"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_servicebus_namespace.sb.name == "test-servicebus"
    error_message = "Service Bus name did not match"
  }
}
