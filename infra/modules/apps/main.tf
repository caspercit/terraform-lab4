resource "azurerm_service_plan" "main" {
  name                = "asp-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

# Infraestructura de frontend; falta publicar el build React y definir su arranque.
resource "azurerm_linux_web_app" "web" {
  name                = "app-${var.suffix}-web-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  site_config {
    always_on           = false
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack {
      node_version = var.node_version
    }
  }
  app_settings = merge(
    { "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true" },
    var.application_insights_connection_string == null ? {} : {
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
    }
  )
  tags = var.tags
}

# API Java/Spring Boot. Integracion VNet solo de salida, entrada HTTPS publica.
resource "azurerm_linux_web_app" "api" {
  name                      = "app-${var.suffix}-api-${var.unique_suffix}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  service_plan_id           = azurerm_service_plan.main.id
  virtual_network_subnet_id = var.integration_subnet_id
  https_only                = true
  identity { type = "SystemAssigned" }
  site_config {
    always_on           = false
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack {
      java_version        = var.java_version
      java_server         = "JAVA"
      java_server_version = var.java_version
    }
  }
  app_settings = merge(
    { "SPRING_PROFILES_ACTIVE" = "azure", "WEBSITE_VNET_ROUTE_ALL" = "1" },
    var.database_host == null ? {} : {
      "PGHOST"     = var.database_host
      "PGPORT"     = "5432"
      "PGDATABASE" = "cafesoft"
      "PGUSER"     = var.database_login
      # Intencional: password NO aqui. Cargar secreto de modo seguro en Azure.
    },
    var.application_insights_connection_string == null ? {} : {
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
    }
  )
  tags = var.tags
}
