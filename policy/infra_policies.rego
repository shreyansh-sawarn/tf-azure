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

# 3. Deny if public network access is enabled in production (example logic)
# This is a bit complex as it depends on knowing the environment from context
# For now, let's just show a general check
deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "azurerm_mssql_server"
    resource.change.after.public_network_access_enabled == true
    # You could add logic here to only check for PROD
    msg := sprintf("SQL Server %v has public network access enabled. Use private endpoints instead.", [resource.address])
}
