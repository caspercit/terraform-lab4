output "resource_group" {
  value = azurerm_resource_group.main.name
}
output "virtual_network" {
  value = module.network.vnet_name
}
output "vnet_address_space" {
  value = module.network.vnet_address_space
}
output "subnets" {
  value = module.network.subnet_names
}
output "storage_account" {
  value = var.enable_storage ? module.storage[0].name : null
}
output "application_insights" {
  value = var.enable_monitoring ? module.monitoring[0].application_insights_name : null
}
output "api_url" {
  value = var.enable_apps ? module.apps[0].api_url : null
}
output "web_url" {
  value = var.enable_apps ? module.apps[0].web_url : null
}
output "postgres_fqdn" {
  value = var.enable_database ? module.database[0].fqdn : null
}
