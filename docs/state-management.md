# State Management Strategy

This project implements a robust, enterprise-grade state management strategy using **Azure Blob Storage** as the remote backend, orchestrated by **Terragrunt**.

## 1. Remote Backend Configuration

Terraform state is stored remotely in an Azure Storage Account. This ensures that the state is shared among team members and preserved across CI/CD runs.

### Bootstrapping the Backend
Before the first deployment, the remote state infrastructure itself must exist. We provide an automated script to handle this:

- **Script:** `scripts/bootstrap-state.sh`
- **Action:** Provisions the dedicated Resource Group, Storage Account, and Container required for remote state.
- **Usage:**
  ```bash
  ./scripts/bootstrap-state.sh <subscription_id> <location>
  ```

### Terragrunt Orchestration
We use the `remote_state` block in the root `terragrunt.hcl` to dynamically generate backend configurations for every stack:

```hcl
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "tf-azure-terraform-state-rg"
    storage_account_name = "tfazuretfstate"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}
```

## 2. State Locking

To prevent concurrent modifications and potential state corruption, we utilize **Azure Blob Leasing** for state locking.

- **Mechanism:** When a user or CI/CD process runs `apply`, Terraform acquires a lease on the state blob.
- **Protection:** Any other process attempting to modify the same state will receive a "State Locked" error until the lease is released.

## 3. Access Control (IAM)

Access to the state files follows the **Principle of Least Privilege**:

- **Human Access:** Developers are granted `Storage Blob Data Reader` for debugging, but only the CI/CD Service Principal has `Storage Blob Data Contributor`.
- **Infrastructure Isolation:** The state storage account is isolated in a dedicated management resource group.

## 4. Disaster Recovery for State

The state storage account is configured with multi-layered protection:

- **Versioning:** Enabled on the storage blob to allow for easy rollback to previous state versions in case of accidental corruption.
- **Geo-Redundancy (GRS):** In production, the state is replicated to a secondary region to survive a regional Azure outage.
- **Soft Delete:** Enabled for 14 days to prevent malicious or accidental deletion of the entire state container.

## 5. Directory Structure & State Paths

By using `${path_relative_to_include()}/terraform.tfstate` in our Terragrunt config, the state is logically organized to match our "Grouped Stacks" architecture:

```text
tfstate/
├── dev/
│   ├── networking/terraform.tfstate
│   ├── compute/terraform.tfstate
│   └── ...
└── prod/
    ├── networking/terraform.tfstate
    └── ...
```

This ensures that a failure in one stack (e.g., `web`) does not affect the state or stability of another stack (e.g., `foundation`).
