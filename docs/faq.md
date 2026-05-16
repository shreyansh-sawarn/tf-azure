# Frequently Asked Questions (FAQ)

## 1. Why use Terragrunt instead of vanilla Terraform?
Terragrunt allows us to keep our configurations **DRY (Don't Repeat Yourself)**. It handles remote state generation, multi-environment deployments, and complex module dependencies (like `compute` needing IDs from `networking`) much more elegantly than vanilla Terraform.

## 2. Why use Mock Providers for testing?
Mock Providers (introduced in Terraform 1.7) allow us to run `terraform test` in a CI/CD pipeline without needing an active Azure subscription. This provides **fast, cost-free validation** of our module logic, naming conventions, and variable constraints before any real resources are touched.

## 3. Is this project compatible with OpenTofu?
**Yes.** This project is 100% compatible with OpenTofu 1.6+ and Terraform 1.5+. We strictly use standard HCL and registry providers to ensure no vendor lock-in.

## 4. How do I add a new environment (e.g., 'staging')?
1. Create a new directory `environments/staging`.
2. Copy `environments/dev/env.hcl` and update the values.
3. Replicate the logical stacks (e.g., `networking`, `compute`) and update their `terragrunt.hcl` to point to the new staging environment.

## 5. How are secrets managed?
We avoid secret sprawl by using **Azure Managed Identities**. Instead of passing database passwords or service principal keys, we assign roles directly to our resources (e.g., granting a VM identity access to a Key Vault). This is the most secure "Secretless" architecture pattern.

## 6. How do I update a core module?
Modify the code in the `modules/` directory. Because we use **local module sources** in our Terragrunt stacks, any change to a module is immediately reflected when you run a `plan` in the environment directory. Remember to update the module's `unit.tftest.hcl` if you add new variables or resources.
