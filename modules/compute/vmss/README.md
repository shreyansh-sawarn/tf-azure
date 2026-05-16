# Virtual Machine Scale Set (VMSS) Module

Provisions a Linux Virtual Machine Scale Set with auto-scaling capabilities and load balancer integration.

## Features
- Linux-based VMSS
- User-Assigned Managed Identity support
- Built-in CPU-based auto-scaling rules
- Load balancer backend pool integration

## Usage

```hcl
module "vmss" {
  source = "../vmss"

  name                 = "web-vmss"
  resource_group_name  = "compute-rg"
  location             = "eastus"
  sku                  = "Standard_B1s"
  instances            = 2
  admin_ssh_key_public = "ssh-rsa ..."
  subnet_id            = module.vnet.subnet_ids["app"]
  identity_ids         = [module.identity.id]
}
```
