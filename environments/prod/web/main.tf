module "app_service_plan" {
  source = "../../../modules/web/app_service_plan"

  app_service_plan_name = var.app_service_plan_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  os_type               = var.asp_os_type
  sku_name              = var.asp_sku_name
  tags                  = var.tags
}

module "web_app" {
  source = "../../../modules/web/web_app"

  app_service_name    = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = module.app_service_plan.id
  tags                = var.tags
}

module "function_app" {
  source = "../../../modules/web/function_app"

  function_app_name          = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = module.app_service_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  tags                       = var.tags
}

module "app_insights" {
  source = "../../../modules/web/app_insights"

  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.log_analytics_id
  tags                = var.tags
}

module "public_lb" {
  source = "../../../modules/networking/load_balancer"

  name                = var.public_lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Public"
  tags                = var.tags
}

output "web_app_default_hostname" {
  value = module.web_app.default_hostname
}
