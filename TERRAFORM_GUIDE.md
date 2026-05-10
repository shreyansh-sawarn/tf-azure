# Terraform Best Practices & Usage Guide

This guide outlines the conventions and workflows used in this repository.

## 1. Naming Conventions
We follow a consistent naming pattern: `${project}-${environment}-${resource_type}`.
- Example: `tfazure-dev-vnet`
- Note: Some resources like Storage Accounts have stricter naming rules (no hyphens, lowercase) and are handled automatically within the modules.

## 2. Module Principles
- **Encapsulation:** Modules should own their resources and expose only necessary variables and outputs.
- **Validation:** Use `terraform fmt` and `terraform validate` locally to ensure code quality.
- **Implicit Dependencies:** We use output-to-input variable passing to manage dependencies between modules (e.g., passing a Subnet ID from Networking to Compute).

## 3. High Availability Strategy
- **Storage:** Defaulting to `GRS` (Geo-Redundant Storage) for critical data.
- **Compute:** Utilizing `Availability Sets` to ensure VM uptime during maintenance or hardware failure.
- **Web:** Using `Service Plans` with production-grade SKUs and `Application Insights` for proactive monitoring.

## 4. Security Practices
- **Secrets:** Never hardcode secrets. Use `sensitive = true` in variables.
- **Key Vault:** All environments include a Key Vault for centralized secret management.
- **Networking:** Minimal exposure with NSGs and perimeter protection via Azure Firewall.

## 5. Deployment Workflow
1.  **Selection:** Choose an environment (e.g., `environments/dev`).
2.  **Configuration:** Edit `variables.tf` or create `terraform.tfvars`.
3.  **Authentication:** Authenticate via Azure CLI (`az login`).
4.  **Execution:**
    ```bash
    terraform init
    terraform plan -out=tfplan
    terraform apply "tfplan"
    ```

## 6. Cleanup
To avoid unnecessary costs, always destroy resources when they are no longer needed:
```bash
terraform destroy
```

---
*Follow these guidelines to maintain the integrity and scalability of your infrastructure.*
