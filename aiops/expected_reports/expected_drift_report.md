# 🤖 AI IaC Drift Detection & Compliance Analysis Report

**Audit Timestamp:** 2026-05-23T16:20:00Z  
**Target Environment:** `environments/dev`  
**Status:** 🔴 CRITICAL - Drift and OPA Policy Violations Detected

---

## 📋 Executive Summary
A scheduled infrastructure audit compared the live Azure state against the Git-defined configuration (`environments/dev`). The comparison detected **3 drifted resources** with **5 active policy violations** against the governance rules in `policy/infra_policies.rego`.

* **Security Drift:** SQL Server public access enabled (High Severity).
* **Cost Drift:** Virtual Machine scaled up from burstable size to expensive tier (Medium Severity).
* **Governance Drift:** Storage container created out-of-band with missing tags and open access (High Severity).

---

## 🔍 Drift & Policy Violations Breakdown

### 1. Compute Stack: Virtual Machine Resize
* **Resource Address:** `module.compute.azurerm_linux_virtual_machine.dev_vm`
* **Change Details:**
  * Property `size`: `"Standard_B2s"` ➔ `"Standard_D4s_v3"`
* **Compliance Failure:**
  * ❌ `VM module.compute.azurerm_linux_virtual_machine.dev_vm has an expensive size (Standard_D4s_v3). Allowed sizes are: [Standard_B1s, Standard_B2s, Standard_DS1_v2]` (OPA Rule #8)
* **Estimated Financial Impact:** `+$148.00 / month`

#### 🛠️ Revert Action (Cloud ➔ Git Alignment)
To revert the virtual machine to the approved size via Azure CLI:
```bash
az vm resize \
  --resource-group tf-azure-dev-rg \
  --name dev-vm \
  --size Standard_B2s \
  --no-wait
```

#### 🔄 Adopt Action (Git ➔ Cloud Alignment)
To adopt the change into your codebase, modify `environments/dev/compute/terragrunt.hcl`:
```hcl
inputs = {
  # WARNING: This size exceeds non-production limits and violates OPA Rule #8. 
  # You must seek policy exceptions or use Standard_B2s instead.
  vm_size = "Standard_D4s_v3"
}
```

---

### 2. Database Stack: SQL Server Firewall Exposure
* **Resource Address:** `module.database.azurerm_mssql_server.dev_sql`
* **Change Details:**
  * Property `public_network_access_enabled`: `false` ➔ `true`
* **Compliance Failure:**
  * ❌ `SQL Server module.database.azurerm_mssql_server.dev_sql has public network access enabled. Use private endpoints instead.` (OPA Rule #3)
* **Security Risk:** High. Exposes the database to direct internet routing, bypassing private link integrations and increasing threat vectors.

#### 🛠️ Revert Action (Cloud ➔ Git Alignment)
To disable public access via Azure CLI:
```bash
az sql server update \
  --resource-group tf-azure-dev-rg \
  --name dev-sql-server \
  --public-network-access Disabled
```

#### 🔄 Adopt Action (Git ➔ Cloud Alignment)
Adopting this change is **NOT RECOMMENDED** because it violates security policies. If an exception is required, update `environments/dev/database/terragrunt.hcl`:
```hcl
inputs = {
  public_network_access_enabled = true
}
```

---

### 3. Storage Stack: Out-of-Band Container Creation
* **Resource Address:** `module.storage.azurerm_storage_container.temp_logs`
* **Change Details:**
  * Resource was **created manually** directly in Azure.
  * Property `container_access_type`: `"private"` ➔ `"blob"` (Public read access)
* **Compliance Failures:**
  * ❌ `Resource module.storage.azurerm_storage_container.temp_logs is missing mandatory 'Environment' tag` (OPA Rule #1)
  * ❌ `Resource module.storage.azurerm_storage_container.temp_logs is missing mandatory 'Project' tag` (OPA Rule #1)
  * ❌ `Storage Container module.storage.azurerm_storage_container.temp_logs must have access type 'private'` (OPA Rule #4)

#### 🛠️ Revert Action (Cloud ➔ Git Alignment)
To delete this out-of-band resource completely:
```bash
az storage container delete \
  --account-name devtfstate \
  --name temp-logs \
  --auth-mode login
```
Alternatively, to secure the container:
```bash
az storage container set-permission \
  --account-name devtfstate \
  --name temp-logs \
  --public-access off \
  --auth-mode login
```

#### 🔄 Adopt Action (Git ➔ Cloud Alignment)
Add this container definition to your storage configuration file in `environments/dev/foundation/terragrunt.hcl`:
```hcl
inputs = {
  containers = [
    {
      name        = "temp-logs"
      access_type = "private" # Restored to private to satisfy policy
      tags = {
        Environment = "Dev"
        Project     = "tf-azure"
      }
    }
  ]
}
```

---

## 🚦 Action Items & Next Steps

1. **Security Incidents (Immediate Revert Suggested):**
   * Run the CLI commands to disable public network access on `dev-sql-server`.
   * Run the CLI commands to secure or delete the `temp-logs` storage container.
2. **Code Syncing (Optional):**
   * If the VM resize is permanent and approved, request a policy exemption and apply the HCL patch to update the VM size variable in `environments/dev/compute/terragrunt.hcl`.
