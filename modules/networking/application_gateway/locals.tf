locals {
  # Resource naming
  pip_name = "${var.name}-pip"

  # Conditional configuration
  waf_config_list = var.waf_enabled ? [1] : []
}
