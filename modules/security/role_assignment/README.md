# Role Assignment Module

Manages Azure Role Based Access Control (RBAC) by assigning roles to identities at specific scopes.

## Features
- Scope-agnostic role assignment (Subscription, RG, Resource)
- Supports built-in and custom roles
- Principle of Least Privilege enablement

## Usage

```hcl
module "rbac" {
  source = "../role_assignment"

  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.identity.principal_id
}
```
