module "mssql_server" {
  source = "../../../modules/database/mssql_server"

  name                          = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  admin_username                = var.sql_admin_username
  admin_password                = var.sql_admin_password
  public_network_access_enabled = var.sql_public_network_access
  tags                          = var.tags
}

module "mssql_database" {
  source = "../../../modules/database/mssql_database"

  name      = var.sql_db_name
  server_id = module.mssql_server.server_id
  sku_name  = var.sql_db_sku
  tags      = var.tags
}

module "storage_account" {
  source = "../../../modules/storage/storage_account"

  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.storage_tier
  replication_type              = var.storage_replication
  public_network_access_enabled = var.storage_public_network_access
  containers                    = var.storage_containers
  tags                          = var.tags
}

output "sql_server_id" {
  value = module.mssql_server.server_id
}

output "storage_account_id" {
  value = module.storage_account.storage_account_id
}
