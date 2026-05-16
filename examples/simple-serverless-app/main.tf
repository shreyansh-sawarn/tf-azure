terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Remove for actual deployment if you want to use your local creds
  # subscription_id = "..."
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "log_analytics" {
  source = "../../modules/monitoring/log_analytics"

  name                = "${var.project_prefix}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

module "app_insights" {
  source = "../../modules/web/app_insights"

  name                = "${var.project_prefix}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = module.log_analytics.id
  tags                = var.tags
}

module "app_service_plan" {
  source = "../../modules/web/app_service_plan"

  app_service_plan_name = "${var.project_prefix}-asp"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  os_type               = "Linux"
  sku_name              = "B1" # Cost-optimized Burstable tier
  tags                  = var.tags
}

module "web_app" {
  source = "../../modules/web/web_app"

  app_service_name    = "${var.project_prefix}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = module.app_service_plan.id
  tags                = var.tags
}

module "sql_server" {
  source = "../../modules/database/mssql_server"

  name                          = "${var.project_prefix}-sql"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  admin_username                = "sqladmin"
  admin_password                = var.admin_password
  public_network_access_enabled = true # Enabled for demo PaaS connectivity
  tags                          = var.tags
}

module "sql_database" {
  source = "../../modules/database/mssql_database"

  name                      = "appdb"
  server_id                 = module.sql_server.server_id
  sku_name                  = "Basic" # Cost-optimized tier
  zone_redundant            = false
  storage_account_type      = "Local"
  short_term_retention_days = 7
  tags                      = var.tags
}
