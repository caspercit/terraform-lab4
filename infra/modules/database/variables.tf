variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "suffix" { type = string }
variable "unique_suffix" { type = string }
variable "vnet_id" { type = string }
variable "delegated_subnet_id" { type = string }
variable "admin_login" { type = string }
variable "admin_password" { type = string; sensitive = true; default = null }
variable "postgres_sku" { type = string }
variable "postgres_version" { type = string }
variable "tags" { type = map(string) }
