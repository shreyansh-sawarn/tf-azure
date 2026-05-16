# Infrastructure Engineering & Deployment Guide

This guide details the technical standards, architectural decisions, and operational workflows implemented in the `tf-azure` project.

## 1. Architectural Pattern: Grouped Stacks

Unlike traditional "flat" Terraform or over-decomposed Terragrunt structures, this project uses **Logical Stacks**. 

### Why this approach?
- **Operational Efficiency:** Reduces the number of `run-all` dependency nodes from 20+ to 7, speeding up deployment and reducing state lock contention.
- **Architectural Clarity:** Grouping VNET, Firewalls, and Route Tables into a single `networking` stack reflects how these services are managed in the real world.
- **Atomic Rollbacks:** Failures are contained within a service stack, making debugging and state recovery much simpler.

## 2. Advanced Networking: Zero Trust Model

The network architecture implements a **Zero Trust** inspired model:
- **Forced Tunneling:** All outbound traffic from application and database subnets is routed through the **Azure Firewall** via User-Defined Routes (UDR).
- **Layer 7 Defense:** Public traffic is terminated at the **Application Gateway**, where a **WAF (Web Application Firewall)** inspects for OWASP top-10 threats.
- **Service Endpoints:** Critical traffic (SQL, Storage) never leaves the Azure backbone, reducing exposure and increasing performance.

## 3. Automated Quality Assurance

This project treats Infrastructure as **Software**, with a full testing lifecycle:

### 🧪 Unit Testing with Mocking
We use the **Terraform Native Test Framework** (`.tftest.hcl`) with a **Mock Provider** strategy.
- **Benefit:** Allows us to validate complex logic (like dynamic blocks, variable validations, and resource naming) in CI/CD without requiring live Azure credentials or incurring costs.
- **Coverage:** Verified across Compute, Networking, and Database modules.

### 🛡️ Policy-as-Code (OPA)
We use **Conftest (Open Policy Agent)** to enforce governance *before* the first resource is created.
- **Security:** Blocks any storage account or SQL server with public access or insecure TLS.
- **Cost:** Restricts production-grade VM sizes to only be used in the `prod` environment.
- **Compliance:** Enforces mandatory tagging for `Environment` and `Project`.

## 4. Identity & Secretless Architecture

We eliminate the "Secret Sprawl" problem by using **Azure Managed Identities**:
- **Pattern:** Every service (like our VM Scale Set) is assigned a **User-Assigned Identity**.
- **RBAC:** We use a reusable `role_assignment` module to grant that identity the **minimum necessary permissions** (e.g., `Key Vault Secrets User` on a specific vault).
- **Result:** No application secrets, service principal keys, or passwords exist in our Terraform code or environment variables.

## 5. High Availability & Disaster Recovery

### High Availability (HA)
- **VMSS:** Elastic compute that scales automatically based on demand.
- **Load Balancers:** Multi-tiered (Public/Internal) to ensure no single point of failure.
- **Zone Redundancy:** SQL Databases are configured for cross-zone replication in Production.

### Disaster Recovery (DR)
- **RSV:** Centralized Recovery Services Vault protecting VMs with daily backups and a 4-week retention policy.
- **Storage Versioning:** Protecting against data corruption and accidental deletion.
- **Geo-Redundancy:** GRS storage and Geo-Redundant backups for SQL ensuring data survives a regional outage.

---

## 🛠️ Technical Stack Summary
- **Language:** HCL (Terraform 1.5+, OpenTofu 1.6+)
- **Orchestration:** Terragrunt
- **Policy:** Rego (OPA/Conftest)
- **Testing:** Terraform Test Framework
- **Scanning:** tfsec
- **CI/CD:** GitHub Actions
