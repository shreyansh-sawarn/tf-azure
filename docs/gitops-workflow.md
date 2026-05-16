# GitOps & Development Workflow

This project follows a **GitOps** methodology, treating the git repository as the single source of truth for the entire Azure infrastructure.

## 1. Branching Strategy

- **`main`:** Represents the desired state of both `dev` and `prod` environments.
- **`feature/*`:** All changes are developed in feature branches and promoted via Pull Requests.

## 2. CI/CD Lifecycle (GitHub Actions)

Every Pull Request triggers an automated pipeline designed to catch issues early and provide full transparency to reviewers.

### Stage 1: Quality & Security
- **Terraform FMT:** Ensures code complies with canonical style standards.
- **tfsec Scanning:** Scans for security misconfigurations and best practice violations.
- **Policy-as-Code (OPA):** Evaluates the proposed plan against 8+ governance rules (e.g., "no public SQL servers").

### Stage 2: Verification
- **Offline Unit Tests:** Runs `terraform test` with **Mock Providers** to validate module logic and variable constraints without needing Azure access.
- **Infracost:** Generates a cost breakdown and posts it as a PR comment.

### Stage 3: The Terragrunt Plan
- Terragrunt automatically calculates dependencies and generates plans for all affected stacks.
- Reviewers use these plans to verify the impact on the environment.

## 3. Environment Promotion

We use a **Directory-Based Promotion** model supported by Terragrunt:

1. Changes are first applied to the `environments/dev` directory.
2. Once validated in development, the same module versions and configurations are promoted to `environments/prod`.
3. This ensures that the production environment is a known, tested version of the development environment.

## 4. Operational Best Practices

- **Atomic Commits:** Each commit should represent a single logical infrastructure change.
- **State Locking:** The pipeline automatically handles state locking to prevent race conditions during deployment.
- **Secretless CI:** The pipeline uses **GitHub OIDC** or highly scoped Service Principals with Managed Identities, ensuring no secrets are stored in GitHub Actions environment variables.
