locals {
  # Role assignment logic
  create_acr_pull_assignment = var.acr_id != null ? 1 : 0
}
