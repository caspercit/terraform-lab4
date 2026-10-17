resource "azurerm_resource_group" "main" {
  name     = "rg-${local.suffix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  suffix              = local.suffix
  tags                = local.tags
}

module "storage" {
  count               = var.enable_storage ? 1 : 0
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  suffix              = local.suffix
  project_name        = var.project_name
  environment         = var.environment
  unique_suffix       = var.unique_suffix
  tags                = local.tags
}

module "monitoring" {
  count               = var.enable_monitoring ? 1 : 0
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  suffix              = local.suffix
  tags                = local.tags
}

module "database" {
  count                  = var.enable_database ? 1 : 0
  source                 = "./modules/database"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  suffix                 = local.suffix
  unique_suffix          = var.unique_suffix
  vnet_id                = module.network.vnet_id
  delegated_subnet_id    = module.network.database_subnet_id
  admin_login            = var.postgres_admin_login
  admin_password         = var.postgres_admin_password
  postgres_sku           = var.postgres_sku
  postgres_version       = var.postgres_version
  tags                   = local.tags
}

module "apps" {
  count                         = var.enable_apps ? 1 : 0
  source                        = "./modules/apps"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  suffix                        = local.suffix
  unique_suffix                 = var.unique_suffix
  integration_subnet_id         = module.network.app_subnet_id
  app_service_sku               = var.app_service_sku
  node_version                  = var.node_version
  java_version                  = var.java_version
  application_insights_connection_string = var.enable_monitoring ? module.monitoring[0].connection_string : null
  database_host                 = var.enable_database ? module.database[0].fqdn : null
  database_login                = var.enable_database ? var.postgres_admin_login : null
  tags                          = local.tags
}
