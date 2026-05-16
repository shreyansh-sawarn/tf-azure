mock_provider "azurerm" {}

run "validate_role_assignment_config" {
  command = plan

  variables {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
    role_definition_name = "Contributor"
    principal_id         = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = azurerm_role_assignment.role.role_definition_name == "Contributor"
    error_message = "Role definition name did not match"
  }
}
