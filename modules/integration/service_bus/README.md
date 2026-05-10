# Service Bus Module

Provisions an Azure Service Bus Namespace with a partitioned queue for asynchronous messaging patterns.

## Usage

```hcl
module "service_bus" {
  source              = "../../../modules/integration/service_bus"
  name                = "my-sb"
  resource_group_name = "my-rg"
  location            = "East US"
  queue_name          = "orders"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the Service Bus Namespace |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `sku` | `string` | `"Standard"` | Namespace SKU |
| `queue_name` | `string` | — | Name of the queue to create |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Service Bus Namespace |
