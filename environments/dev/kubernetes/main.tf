module "aks" {
  source = "../../../modules/compute/aks"

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  node_count          = var.node_count
  node_size           = var.node_size
  subnet_id           = var.subnet_id
  enable_auto_scaling = var.enable_auto_scaling
  min_node_count      = var.min_node_count
  max_node_count      = var.max_node_count

  log_analytics_workspace_id = var.log_analytics_id
  acr_id                     = var.acr_id

  tags = var.tags
}

# The user mentioned Helm releases for ingress, etc.
# In a real scenario, we'd configure the helm provider here.
# For the portfolio, we can demonstrate the logic.

output "cluster_name" {
  value = module.aks.name
}

output "oidc_issuer_url" {
  value = module.aks.oidc_issuer_url
}
