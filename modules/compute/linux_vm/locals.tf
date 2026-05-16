locals {
  # Resource naming
  nic_name = "${var.name}-nic"

  # Conditional logic for SSH keys
  ssh_key_list = var.admin_ssh_key_public != null ? [1] : []
}
