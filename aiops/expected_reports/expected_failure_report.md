# 🚨 AI Deployment Failure Diagnostics Report

**Incident Timestamp:** 2026-05-23T16:35:00Z  
**Failed Command:** `terraform apply -auto-approve tfplan.binary`  
**Failed Environment:** `environments/dev/compute`  
**Status:** 🔴 CRITICAL - Deployment Interrupted

---

## 📋 Incident Summary
A resource deployment failure occurred during the Terragrunt apply execution. The underlying Azure Resource Manager (ARM) API returned a conflict response code due to resource limits constraints.

* **Target Resource:** `module.compute.azurerm_linux_virtual_machine.dev_vm` (VM Name: `dev-vm`)
* **Error Code:** `QuotasExceeded` (HTTP 409 Conflict)
* **Error Core family:** `standardDSv2Family`

---

## 🔍 Root Cause Analysis
The deployment failed because the Azure Subscription core capacity limit for standard `DSv2-series` VMs has been reached in region `eastus2`.

* **Capacity Limit:** `10 Cores` maximum allowed.
* **Currently Allocated:** `8 Cores` actively in use in the subscription.
* **Requested Allocation:** `4 Cores` (for the new virtual machine, standard `Standard_D4s_v3` size uses 4 cores).
* **Deficit**: The request totals **12 Cores**, exceeding your subscription's regional capacity quota limit by **2 Cores**.

---

## 🛠️ Step-by-Step Resolution Blueprint

To resolve this deployment bottleneck, select one of the two resolution tracks:

### Option A: Request an Azure Quota Limit Increase (Recommended for Prod)
Submit a capacity request to Azure via the command line to increase your core limit. You can execute this Azure CLI command if you have subscription owner or contributor rights:

```bash
az capacity request create \
  --subscription "00000000-0000-0000-0000-000000000000" \
  --location "eastus2" \
  --name "standardDSv2Family" \
  --limit 20 \
  --region-quota-limit-type "Standard"
```

*Note: Requests for standard VM SKU quota increases are usually processed automatically by Microsoft within 2 to 5 minutes.*

### Option B: Modify Local HCL Variable to a Burstable VM (Recommended for Dev)
If this is a non-production setup, avoid regional quota increases. Scale down the VM to a size that falls under the standard burstable series (`standardBFamily`), which utilizes separate quotas:

1. Open `environments/dev/compute/terragrunt.hcl`.
2. Locate the `vm_size` input parameter.
3. Replace `Standard_D4s_v3` with the approved burstable size `Standard_B2s` (which uses only 2 cores from standardBFamily):

```diff
inputs = {
-  vm_size = "Standard_D4s_v3"
+  vm_size = "Standard_B2s" # Switch to burstable size to bypass Standard_DSv2 core limits
}
```

4. Re-run `terragrunt apply`.
