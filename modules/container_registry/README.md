# Container Registry Module

Provisions an Azure Container Registry (ACR) for container image management. Admin access is disabled by default for security.

## Usage

```hcl
module "acr" {
  source              = "../../../modules/container_registry"
  name                = "myacr"
  resource_group_name = "my-rg"
  location            = "East US"
  sku                 = "Premium"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the ACR (alphanumeric only) |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `sku` | `string` | `"Standard"` | ACR SKU (Basic, Standard, Premium) |
| `admin_enabled` | `bool` | `false` | Enable admin user |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Container Registry |
| `login_server` | The login server URL |
