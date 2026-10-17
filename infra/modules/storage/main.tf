# Storage de archivos/evidencias. Sin acceso anonimo; consumir con identidad o SAS controlada.
resource "azurerm_storage_account" "main" {
  name                            = "st${var.project_name}${var.environment}${var.unique_suffix}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}
resource "azurerm_storage_container" "evidencias" {
  name                  = "evidencias"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
