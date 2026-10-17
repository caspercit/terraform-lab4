output "name" {
  value = azurerm_storage_account.main.name
}
output "blob_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}
