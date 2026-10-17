variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "suffix" {
  type = string
}
variable "unique_suffix" {
  type = string
}
variable "integration_subnet_id" {
  type = string
}
variable "app_service_sku" {
  type = string
}
variable "node_version" {
  type = string
}
variable "java_version" {
  type = string
}
variable "application_insights_connection_string" {
  type = string
  default = null
}
variable "database_host" {
  type = string
  default = null
}
variable "database_login" {
  type = string
  default = null
}
variable "tags" {
  type = map(string)
}
