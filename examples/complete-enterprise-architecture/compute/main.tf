module "public_lb" {
  source = "../../../modules/networking/load_balancer"

  name                = "${var.name}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Public"
  tags                = var.tags
}

module "vmss" {
  source = "../../../modules/compute/vmss"

  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  sku                  = var.sku
  instances            = var.instances
  subnet_id            = var.subnet_id
  admin_username       = var.admin_username
  admin_ssh_key_public = var.admin_ssh_key_public

  backend_address_pool_ids = [module.public_lb.backend_pool_id]

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>Enterprise Stack Deployed Successfully</h1><p>Environment: Demo</p>" > /var/www/html/index.html
              systemctl start nginx
              EOF
  )

  tags = var.tags
}

output "load_balancer_ip" {
  value = "Check the Azure Portal for the Load Balancer Public IP"
}
