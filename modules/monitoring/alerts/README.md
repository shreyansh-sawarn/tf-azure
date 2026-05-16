# Monitoring Alerts Module

Provisions Azure Monitor Metric Alerts and Action Groups for proactive infrastructure monitoring.

## Features
- Metric Alert for VMSS CPU usage
- Action Group with Email notifications
- Parameterized thresholds and short names

## Usage

```hcl
module "alerts" {
  source = "../alerts"

  resource_group_name = "monitor-rg"
  action_group_name   = "ops-action-group"
  short_name          = "opsalerts"
  admin_email         = "admin@example.com"
  prefix              = "prod"
  target_resource_ids = [module.vmss.id]
}
```
