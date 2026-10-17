output "vnet_name" { value = azurerm_virtual_network.main.name }
output "vnet_id" { value = azurerm_virtual_network.main.id }
output "vnet_address_space" { value = azurerm_virtual_network.main.address_space }
output "app_subnet_id" { value = azurerm_subnet.app.id }
output "database_subnet_id" { value = azurerm_subnet.database.id }
output "subnet_names" {
  value = [azurerm_subnet.app.name, azurerm_subnet.database.name, azurerm_subnet.management.name]
}
