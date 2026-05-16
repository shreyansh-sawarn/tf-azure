resource "azurerm_public_ip" "lb_pip" {
  count               = var.type == "Public" ? 1 : 0
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "frontend"
    public_ip_address_id          = var.type == "Public" ? azurerm_public_ip.lb_pip[0].id : null
    subnet_id                     = var.type == "Internal" ? var.subnet_id : null
    private_ip_address_allocation = var.type == "Internal" ? "Dynamic" : null
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "backend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackendPool"
}

resource "azurerm_lb_probe" "hp" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "HealthProbe"
  port            = var.probe_port
  protocol        = var.probe_protocol
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend.id]
  probe_id                       = azurerm_lb_probe.hp.id
}
