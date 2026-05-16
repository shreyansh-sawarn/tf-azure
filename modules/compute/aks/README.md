# Azure Kubernetes Service (AKS) Module

Provisions a production-grade AKS cluster with advanced security and monitoring integrations.

## Features
- **Azure CNI Networking:** High-performance networking with Azure VNet integration.
- **Workload Identity & OIDC:** Modern identity management for pod-to-Azure communication.
- **Key Vault Secrets Provider:** CSI Driver integration for secure secret management.
- **Observability:** Built-in Azure Monitor (OMS Agent) and Microsoft Defender integration.
- **ACR Integration:** Automated RBAC assignment for ACR pulling.

## Usage

```hcl
module "aks" {
  source = "../aks"

  name                = "main-aks"
  location            = "eastus"
  resource_group_name = "aks-rg"
  dns_prefix          = "mainaks"
  subnet_id           = module.vnet.subnet_ids["app"]
  
  log_analytics_workspace_id = module.log_analytics.id
  acr_id                     = module.acr.id
}
```
