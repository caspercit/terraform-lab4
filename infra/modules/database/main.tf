resource "azurerm_private_dns_zone" "postgresql" {
  name                = "private.${var.suffix}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "link-postgres-${var.suffix}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}
resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "psql-${var.suffix}-${var.unique_suffix}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.postgres_version
  administrator_login           = var.admin_login
  administrator_password        = var.admin_password
  storage_mb                    = 32768
  sku_name                      = var.postgres_sku
  backup_retention_days         = 7
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.postgresql.id
  public_network_access_enabled = false
  tags                          = var.tags
  depends_on                    = [azurerm_private_dns_zone_virtual_network_link.postgresql]
  lifecycle {
    precondition {
      condition     = var.admin_password != null && length(coalesce(var.admin_password, "")) >= 8
      error_message = "Para PostgreSQL, configura TF_VAR_postgres_admin_password con al menos 8 caracteres."
    }
  }
}
resource "azurerm_postgresql_flexible_server_database" "cafesoft" {
  name      = "cafesoft"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
