mock_provider "azurerm" {}

run "validate_aks_config" {
  command = plan

  variables {
    name                = "test-aks"
    location            = "eastus"
    resource_group_name = "test-rg"
    dns_prefix          = "testaks"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"

    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"

    node_count = 3
    node_size  = "Standard_DS2_v2"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_kubernetes_cluster.aks.name == "test-aks"
    error_message = "AKS name did not match"
  }

  assert {
    condition     = azurerm_kubernetes_cluster.aks.default_node_pool[0].node_count == 3
    error_message = "AKS node count did not match"
  }

  assert {
    condition     = azurerm_kubernetes_cluster.aks.workload_identity_enabled == true
    error_message = "Workload Identity should be enabled"
  }

  assert {
    condition     = azurerm_kubernetes_cluster.aks.network_profile[0].network_plugin == "azure"
    error_message = "Azure CNI should be the default network plugin"
  }
}

# Apply-mode test: oidc_issuer_url and the cluster ID are computed attributes
# that only resolve to concrete mock values after apply, not at plan time.
run "apply_creates_aks_cluster" {
  command = apply

  variables {
    name                = "test-aks"
    location            = "eastus"
    resource_group_name = "test-rg"
    dns_prefix          = "testaks"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"

    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"

    node_count = 3
    node_size  = "Standard_DS2_v2"

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = output.id != null
    error_message = "AKS cluster id output should be populated after apply"
  }

  assert {
    condition     = output.oidc_issuer_url != null
    error_message = "oidc_issuer_url should be populated after apply since oidc_issuer_enabled is true"
  }
}
