# Contributing to tf-azure

Thank you for your interest in contributing! We follow professional standards to ensure infrastructure safety and maintainability.

## Code Standards

### 1. Granular Modularity
All resources must be implemented as atomic modules in the `modules/` directory. Avoid creating composite modules that manage unrelated resource types.

### 2. Terragrunt Orchestration
Environment configurations must be managed via Terragrunt in the `environments/` directory. Ensure all `dependency` blocks include `mock_outputs` for validation support.

### 3. Naming Conventions
Follow the `${project}-${environment}-${resource}` naming pattern consistently.

### 4. Security
- Never hardcode secrets.
- Use `sensitive = true` for sensitive variables.
- All new modules must pass `tfsec` scanning.

## Development Workflow

1. **Fork the repo** and create your branch from `main`.
2. **Implement changes** following the granular module pattern.
3. **Format and Validate**:
   ```bash
   make all
   ```
4. **Push and Open a PR**:
   - The CI pipeline will automatically run security scans and generate a cost estimate.
   - A `terragrunt plan` will be generated for reviewers to inspect.

## Code Review Process
All PRs require approval from at least one maintainer. Reviewers will check for:
- Adherence to naming conventions.
- Correct dependency mapping in Terragrunt.
- Absence of security misconfigurations (e.g., open NSG rules).

---
*By contributing, you help make this a high-quality showcase of Azure platform engineering.*
