mock_provider "azurerm" {}

run "validate_key_vault_config" {
  command = plan

  variables {
    name                = "test-kv"
    resource_group_name = "test-rg"
    location            = "eastus"
    sku_name            = "standard"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_key_vault.vault.name == "test-kv"
    error_message = "Key Vault name did not match"
  }

  assert {
    condition     = azurerm_key_vault.vault.sku_name == "standard"
    error_message = "Key Vault SKU did not match"
  }

  assert {
    condition     = azurerm_key_vault.vault.soft_delete_retention_days >= 7
    error_message = "Soft delete retention should be at least 7 days"
  }
}

run "reject_invalid_sku_name" {
  command = plan

  variables {
    name                = "test-kv"
    resource_group_name = "test-rg"
    location            = "eastus"
    sku_name            = "ultra" # only "standard" or "premium" are valid Key Vault SKUs
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  expect_failures = [
    var.sku_name,
  ]
}

# Apply-mode test: vault_uri is a computed attribute that only resolves to a
# concrete mock value after apply, not at plan time.
run "apply_creates_key_vault" {
  command = apply

  variables {
    name                = "test-kv"
    resource_group_name = "test-rg"
    location            = "eastus"
    sku_name            = "standard"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = output.id != null
    error_message = "Key Vault id output should be populated after apply"
  }

  assert {
    condition     = output.vault_uri != null
    error_message = "vault_uri output should be populated after apply"
  }
}
