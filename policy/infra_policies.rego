package main

# Returns the tags map for a resource's post-change state, defaulting to {} if the
# resource has no `tags` block at all, or if `tags` is explicitly null. Without this,
# `resource.change.after.tags.Environment` on a null/missing tags value risks the rule
# silently failing to evaluate instead of correctly flagging the missing tag.
safe_tags(resource) := tags {
    raw := object.get(resource.change.after, "tags", {})
    raw != null
    tags := raw
} else := {}

# 1. Deny if standard tags are missing
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    tags := safe_tags(resource)
    not tags.Environment
    msg := sprintf("Resource %v is missing mandatory 'Environment' tag", [resource.address])
}

deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    tags := safe_tags(resource)
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

deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_mssql_server"
    resource.change.after.public_network_access_enabled == true
    msg := sprintf("SQL Server %v has public network access enabled. Use private endpoints instead.", [resource.address])
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

# 6. Deny Linux VM password authentication (SSH preferred)
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_linux_virtual_machine"
    resource.change.after.disable_password_authentication == false
    msg := sprintf("Linux VM %v must use SSH keys. Password authentication is disabled for security.", [resource.address])
}

# 7. Enforce HTTPS only for Storage Accounts
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_storage_account"
    resource.change.after.https_traffic_only_enabled == false
    msg := sprintf("Storage Account %v must have HTTPS traffic only enabled", [resource.address])
}

# 8. Cost Control: Limit VM sizes in non-production environments only.
# Scoped by the resource's own Environment tag (see environments/*/env.hcl, which tag
# every resource "dev" or "prod") so this never blocks legitimately larger prod VM sizes
# that are otherwise valid per the module's own vm_size validation in variables.tf.
deny[msg] {
    resource := input.resource_changes[_]
    resource.mode == "managed"
    resource.type == "azurerm_linux_virtual_machine"
    tags := safe_tags(resource)
    tags.Environment != "prod"
    allowed_sizes := ["Standard_B1s", "Standard_B2s", "Standard_DS1_v2"]
    actual_size := resource.change.after.size
    not count([s | s := allowed_sizes[_]; s == actual_size]) > 0
    msg := sprintf("VM %v has an expensive size (%v) for a non-production environment. Allowed sizes are: %v", [resource.address, actual_size, allowed_sizes])
}
