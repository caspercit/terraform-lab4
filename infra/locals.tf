locals {
  suffix = "${var.project_name}-${var.environment}-mxc-${var.instance}"
  tags = merge(var.tags, {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  })
}
