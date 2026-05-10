# Terragrunt & Terraform Best Practices Guide

This guide outlines the conventions and workflows used in this repository, emphasizing the use of **Terragrunt** for DRY orchestration.

## 1. Naming Conventions
We follow a consistent naming pattern: `${project}-${environment}-${resource_type}`.
- Example: `tfazure-dev-vnet`
- Note: Storage accounts and other restricted resources are handled automatically by the modules.

## 2. Terragrunt Principles
- **DRY Providers & Backends:** Managed centrally in `environments/terragrunt.hcl`.
- **Dependency Management:** Use `dependency` blocks to pass outputs between components (e.g., Resource Group to Networking).
- **Environment Isolation:** Use `env.hcl` in each environment folder to define local variables.

## 3. High Availability Strategy
- **Storage:** Defaulting to `GRS` (Geo-Redundant Storage).
- **Compute:** Utilizing `Availability Sets` for VM uptime.
- **Web:** Production-grade SKUs and `Application Insights` for monitoring.

## 4. Security Practices
- **Key Vault:** Centralized secret management integrated into all environments.
- **Perimeter Security:** Perimeter protection via **Azure Firewall** in the networking module.
- **Sensitive Data:** Marked with `sensitive = true` and managed via Key Vault where possible.

## 5. Deployment Workflow (Terragrunt)
1.  **Authentication:** Authenticate via Azure CLI (`az login`).
2.  **Selection:** Choose an environment (e.g., `cd environments/dev`).
3.  **Plan All:**
    ```bash
    terragrunt run-all plan
    ```
4.  **Apply All:**
    ```bash
    terragrunt run-all apply
    ```
5.  **Targeted Action:** To manage a single component:
    ```bash
    cd networking
    terragrunt plan
    ```

## 6. Cleanup
To avoid unnecessary costs, use the `run-all` command:
```bash
terragrunt run-all destroy
```

---
*Follow these guidelines to maintain the integrity and scalability of your infrastructure.*
