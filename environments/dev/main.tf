resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

module "networking" {
  source              = "../../modules/networking"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "${var.project_name}-${var.environment}-vnet"
  enable_firewall     = true
  tags                = var.tags
}

module "storage" {
  source               = "../../modules/storage"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = replace("${var.project_name}${var.environment}st", "-", "")
  containers           = ["data", "logs"]
  tags                 = var.tags
}

module "database" {
  source              = "../../modules/database"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sql_server_name     = "${var.project_name}-${var.environment}-sql"
  sql_db_name         = "appdb"
  admin_password      = "P@ssw0rd1234!" # In production, use Key Vault or Sensitive Variable
  tags                = var.tags
}

module "security" {
  source              = "../../modules/security"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  keyvault_name       = "${var.project_name}-${var.environment}-kv"
  tags                = var.tags
}

module "compute" {
  source              = "../../modules/compute"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vm_name             = "${var.project_name}-${var.environment}-vm"
  subnet_id           = module.networking.subnet_ids["app"]
  admin_password      = "P@ssw0rd1234!" # In production, use Key Vault
  tags                = var.tags
}

module "web" {
  source                     = "../../modules/web"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  app_service_plan_name      = "${var.project_name}-${var.environment}-asp"
  app_service_name           = "${var.project_name}-${var.environment}-webapp"
  function_app_name          = "${var.project_name}-${var.environment}-func"
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.primary_access_key
  tags                       = var.tags
}

module "integration" {
  source              = "../../modules/integration"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_bus_name    = "${var.project_name}-${var.environment}-sb"
  queue_name          = "orders"
  logic_app_name      = "${var.project_name}-${var.environment}-logic"
  tags                = var.tags
}
