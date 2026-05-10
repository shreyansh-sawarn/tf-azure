# Windows Virtual Machine Module

Provisions an Azure Windows Virtual Machine with a Network Interface, configurable VM size, and optional Availability Set placement. Defaults to Windows Server 2022 Datacenter.

## Usage

```hcl
module "windows_vm" {
  source              = "../../../modules/compute/windows_vm"
  name                = "my-win-vm"
  resource_group_name = "my-rg"
  location            = "East US"
  subnet_id           = module.vnet.subnet_ids["app"]
  admin_password      = var.admin_password
  availability_set_id = module.availability_set.id
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the VM |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `subnet_id` | `string` | — | Subnet ID for the NIC |
| `vm_size` | `string` | `"Standard_B1s"` | VM SKU (validated) |
| `admin_username` | `string` | `"azureuser"` | Admin username |
| `admin_password` | `string` | — | Admin password (sensitive, min 12 chars) |
| `availability_set_id` | `string` | `null` | Optional Availability Set ID |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Virtual Machine |
| `private_ip` | The private IP address of the VM |
