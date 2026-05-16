locals {
  # Logic to determine whether to use a new or existing DNS zone
  dns_zone_id   = var.create_dns_zone ? azurerm_private_dns_zone.zone[0].id : var.existing_dns_zone_id
  dns_zone_name = var.create_dns_zone ? azurerm_private_dns_zone.zone[0].name : var.dns_zone_name
}
