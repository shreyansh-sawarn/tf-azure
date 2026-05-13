package main

import data.terraform.library

# 1. Deny if standard tags are missing
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    tags := resource.change.after.tags
    not tags.Environment
    msg := sprintf("Resource %v is missing mandatory 'Environment' tag", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    tags := resource.change.after.tags
    not tags.Project
    msg := sprintf("Resource %v is missing mandatory 'Project' tag", [resource.address])
}

# 2. Deny if TLS version is less than 1.2
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_storage_account"
    resource.change.after.min_tls_version != "TLS1_2"
    msg := sprintf("Storage Account %v must use TLS 1.2 or higher", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_mssql_server"
    resource.change.after.minimum_tls_version != "1.2"
    msg := sprintf("SQL Server %v must use TLS 1.2 or higher", [resource.address])
}

# 3. Deny if public network access is enabled
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_storage_account"
    resource.change.after.public_network_access_enabled == true
    msg := sprintf("Storage Account %v has public network access enabled. Use private endpoints instead.", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_key_vault"
    resource.change.after.public_network_access_enabled == true
    msg := sprintf("Key Vault %v has public network access enabled. Use private endpoints instead.", [resource.address])
}

# 4. Deny Storage Container public access
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_storage_container"
    resource.change.after.container_access_type != "private"
    msg := sprintf("Storage Container %v must have access type 'private'", [resource.address])
}

# 5. Deny Key Vault soft delete disabled (though it is now enabled by default in Azure)
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_key_vault"
    resource.change.after.soft_delete_retention_days < 7
    msg := sprintf("Key Vault %v must have soft delete retention of at least 7 days", [resource.address])
}
