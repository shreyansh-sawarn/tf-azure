module "log_analytics" {
  source = "../../../modules/monitoring/log_analytics"

  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

module "container_registry" {
  source = "../../../modules/container_registry"

  name                = var.acr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

module "service_bus" {
  source = "../../../modules/integration/service_bus"

  name                = var.service_bus_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sb_sku
  tags                = var.tags
}

module "logic_app" {
  source = "../../../modules/integration/logic_app"

  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

output "log_analytics_id" {
  value = module.log_analytics.id
}

output "acr_login_server" {
  value = module.container_registry.login_server
}

output "acr_id" {
  value = module.container_registry.id
}

module "alerts" {
  source = "../../../modules/monitoring/alerts"

  resource_group_name = var.resource_group_name
  action_group_name   = "${var.log_analytics_name}-action-group"
  short_name          = "opsalerts"
  admin_email         = "ops-team@example.com"
  prefix              = "prod"
  target_resource_ids = [var.vmss_id]
}
