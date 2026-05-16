# Recovery Services Vault Module

Provisions an Azure Recovery Services Vault and a standard VM backup policy.

## Features
- Configurable storage mode (GeoRedundant/LocallyRedundant)
- Pre-configured Daily and Weekly backup retention policies
- Soft delete enabled for security

## Usage

```hcl
module "recovery_vault" {
  source = "../recovery_services_vault"

  name                = "main-rsv"
  location            = "eastus"
  resource_group_name = "security-rg"
  storage_mode_type   = "GeoRedundant"
}
```
