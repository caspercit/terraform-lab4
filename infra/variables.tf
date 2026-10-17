variable "subscription_id" {
  description = "ID de suscripcion; no guardar valores reales en Git. Alternativamente ARM_SUBSCRIPTION_ID."
  type        = string
  default     = null
  sensitive   = true
}
variable "project_name" {
  type        = string
  default     = "cafesoft"
  description = "Nombre corto para los recursos"
  validation {
    condition     = can(regex("^[a-z0-9]{3,12}$", var.project_name))
    error_message = "project_name: 3 a 12 caracteres minusculos o numeros."
  }
}
variable "environment" {
  type    = string
  default = "qa"
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment debe ser dev, qa o prod."
  }
}
variable "location" {
  description = "Region; confirmar disponibilidad y cuotas en la suscripcion."
  type        = string
  default     = "mexicocentral"
}
variable "instance" {
  type    = string
  default = "001"
  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance))
    error_message = "instance debe tener 3 digitos."
  }
}
variable "unique_suffix" {
  description = "4-8 letras/numeros, exclusivo para nombres globales: Storage, Web Apps y PostgreSQL."
  type        = string
  default     = "cambia01"
  validation {
    condition     = can(regex("^[a-z0-9]{4,8}$", var.unique_suffix))
    error_message = "unique_suffix: 4 a 8 caracteres minusculos o numeros."
  }
}
variable "enable_storage" {
  description = "Crear cuenta de Storage y contenedor privado. Puede generar cargos."
  type        = bool
  default     = true
}
variable "enable_monitoring" {
  description = "Crear Log Analytics e Insights. Puede generar cargos por ingesta."
  type        = bool
  default     = false
}
variable "enable_apps" {
  description = "Crear Web App React y Web App Java con plan B1 (con costo); integrar salida de API a VNet."
  type        = bool
  default     = false
}
variable "enable_database" {
  description = "Crear PostgreSQL Flexible Server privado (con costo)."
  type        = bool
  default     = false
}
variable "app_service_sku" {
  description = "B1 soporta integracion de VNet; F1 no sirve para esa conexion."
  type        = string
  default     = "B1"
}
variable "node_version" {
  type    = string
  default = "24-lts"
}
variable "java_version" {
  type    = string
  default = "17"
}
variable "postgres_admin_login" {
  type    = string
  default = "cafeadmin"
}
variable "postgres_admin_password" {
  description = "Solo cuando enable_database=true. Establecer con TF_VAR_postgres_admin_password o tfvars ignorado. Aparece en estado Terraform."
  type        = string
  default     = null
  sensitive   = true
  nullable    = true
}
variable "postgres_sku" {
  description = "Verificar SKU disponibles en region/suscripcion."
  type        = string
  default     = "B_Standard_B1ms"
}
variable "postgres_version" {
  type    = string
  default = "16"
}
variable "tags" {
  type = map(string)
  default = {
    owner       = "equipo-cafesoft"
    cost_center = "practica-academica"
  }
}
