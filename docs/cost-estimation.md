# Cloud Cost Estimation

This project integrates **Infracost** to provide real-time cost visibility for all infrastructure changes. This "Shift-Left" approach ensures that cost is considered during the design and pull-request phase, not just after the bill arrives.

## 1. Local Cost Estimation

You can estimate the cost of your changes locally before committing them.

### Breakdown per Stack
To see a detailed breakdown of costs for a specific stack (e.g., `dev/networking`):

```bash
cd environments/dev/networking
terragrunt run-all init
terragrunt run-all plan -out=tfplan.binary
terragrunt run-all show -json tfplan.binary > tfplan.json
infracost breakdown --path tfplan.json
```

### Breakdown for Entire Environment
Using the root Makefile (if available) or individual stack plans:

```bash
# Example command using the Terragrunt root
terragrunt run-all infracost breakdown --path .
```

## 2. CI/CD Integration (GitOps)

The project includes a GitHub Actions workflow that automates cost estimation for every Pull Request.

### How it works:
1. **Trigger:** A PR is opened or updated.
2. **Execution:** Infracost calculates the cost of the *current* state vs. the *proposed* state.
3. **Visibility:** A summary comment is automatically posted to the PR showing the monthly cost increase/decrease.

## 3. Cost-Optimization Strategies

This project implements several patterns to keep costs low in development while maintaining performance in production:

- **SKU Tiering:** Using `Basic` or `Standard` tiers for SQL and Firewall in `dev`, while upgrading to `Premium` in `prod`.
- **Burstable VMs:** Defaulting to `Standard_B` series VMs in non-production environments.
- **Retention Policies:** Setting shorter Log Analytics and Backup retention periods for `dev` environments.

## 4. Prerequisite
To use Infracost locally, you need an API Key:
1. Install the CLI: `brew install infracost`
2. Register: `infracost register`
3. Set your key: `export INFRACOST_API_KEY=your_key`
