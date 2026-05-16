# User Assigned Identity Module

Provisions an Azure User Assigned Managed Identity for secure service-to-service authentication.

## Features
- Standard User Assigned Managed Identity
- Exposes Principal ID and Client ID for RBAC and configuration
- Promotes secretless architecture

## Usage

```hcl
module "identity" {
  source = "../user_assigned_identity"

  name                = "app-identity"
  location            = "eastus"
  resource_group_name = "security-rg"
}
```
