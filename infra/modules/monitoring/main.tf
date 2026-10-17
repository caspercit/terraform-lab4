resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.1
  tags                = var.tags
}
resource "azurerm_application_insights" "main" {
  name                 = "appi-${var.suffix}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  workspace_id         = azurerm_log_analytics_workspace.main.id
  application_type     = "web"
  daily_data_cap_in_gb = 0.1
  tags                 = var.tags
}
