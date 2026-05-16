locals {
  # Logic for tenant_id (uses current client context if not provided)
  effective_tenant_id = var.tenant_id != "" ? var.tenant_id : data.azurerm_client_config.current.tenant_id
}
