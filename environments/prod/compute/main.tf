module "availability_set" {
  source = "../../../modules/compute/availability_set"

  name                = var.availability_set_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "linux_vm" {
  source = "../../../modules/compute/linux_vm"

  name                = var.linux_vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  vm_size             = var.linux_vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  admin_ssh_key_public = var.admin_ssh_key_public
  availability_set_id  = module.availability_set.id
  tags                = var.tags
}

module "windows_vm" {
  source = "../../../modules/compute/windows_vm"

  name                = var.windows_vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  vm_size             = var.windows_vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id  = module.availability_set.id
  tags                = var.tags
}

module "internal_lb" {
  source = "../../../modules/networking/load_balancer"

  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Internal"
  subnet_id           = var.subnet_id
  tags                = var.tags
}

# Sophisticated Identity Pattern: Least Privilege
module "vm_identity" {
  source = "../../../modules/security/user_assigned_identity"

  name                = "${var.linux_vm_name}-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# SOPHISTICATED RBAC: Grant VM Identity 'Key Vault Secrets User' 
module "rbac_vm_to_kv" {
  source = "../../../modules/security/role_assignment"

  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.vm_identity.principal_id
}

module "vmss" {
  source = "../../../modules/compute/vmss"

  name                 = "${var.linux_vm_name}-ss"
  location             = var.location
  resource_group_name  = var.resource_group_name
  sku                  = var.linux_vm_size
  subnet_id            = var.subnet_id
  admin_username       = var.admin_username
  admin_ssh_key_public = var.admin_ssh_key_public
  backend_address_pool_ids = [module.internal_lb.backend_pool_id]
  identity_ids         = [module.vm_identity.id]
  tags                 = var.tags
}

output "vmss_id" {
  value = module.vmss.id
}

output "linux_vm_private_ip" {
  value = module.linux_vm.private_ip_address
}

output "windows_vm_private_ip" {
  value = module.windows_vm.private_ip_address
}
