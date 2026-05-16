# tf-azure: Enterprise-Grade Azure Infrastructure Architecture

[![Terragrunt CI/CD](https://github.com/shreyansh-sawarn/tf-azure/actions/workflows/terragrunt.yml/badge.svg)](https://github.com/shreyansh-sawarn/tf-azure/actions/workflows/terragrunt.yml)
[![Azure Verified](https://img.shields.io/badge/Azure-Verified-0089D6?logo=microsoftazure)](https://azure.microsoft.com/)
[![OpenTofu Compatible](https://img.shields.io/badge/OpenTofu-Compatible-FF6B6B?logo=opentofu)](https://opentofu.org/)
[![Terraform 1.5+](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform)](https://www.terraform.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Last Commit](https://img.shields.io/github/last-commit/shreyansh-sawarn/tf-azure)](https://github.com/shreyansh-sawarn/tf-azure/commits/main)
[![Top Language](https://img.shields.io/github/languages/top/shreyansh-sawarn/tf-azure)](https://github.com/shreyansh-sawarn/tf-azure)

A comprehensive, production-ready Azure infrastructure template repository. This project demonstrates high-level cloud architecture, implementing **Security by Design**, **Disaster Recovery**, and **Proactive Observability** using **Terragrunt** and **Terraform/OpenTofu**.

## 🚀 Key Features

- **🏗️ Grouped Stacks Architecture:** Optimized Terragrunt structure that groups related resources into logical services (Foundation, Networking, Compute, Data, etc.) for better operational manageability.
- **🛡️ Advanced Security & Governance:** 
  - **Policy-as-Code:** 8+ production-grade **OPA (Open Policy Agent)** rules enforcing TLS 1.2, private-only storage, and mandatory tagging.
  - **Secretless Auth:** Sophisticated IAM patterns using **User-Assigned Managed Identities** and Granular RBAC.
  - **Layer 7 Protection:** **Application Gateway with WAF (OWASP)** and **Azure Firewall** integrated via forced tunneling (UDR).
- **📈 High Availability & Elasticity:** 
  - **Auto-Scaling:** Virtual Machine Scale Sets (VMSS) with CPU-based scaling.
  - **Load Balancing:** Tiered Public and Internal Load Balancers for service resiliency.
  - **Redundancy:** Cross-region GRS storage and Zone-Redundant SQL databases.
- **🔄 Disaster Recovery:** 
  - **Recovery Services Vault:** Automated VM backup policies and soft-delete protection.
  - **Database PITR:** Point-in-time recovery enabled with up to 35-day retention.
- **🧪 Robust Validation:** 
  - **Offline Unit Testing:** Automated **Terraform Native Testing** (`.tftest.hcl`) utilizing **Mock Providers** for CI/CD validation without Azure credentials.
  - **Automated Linting:** Integrated `terraform fmt` and `tfsec` security scanning.
- **🔓 Open Source Friendly:** 100% compatible with **OpenTofu 1.6+** and Terraform 1.5+, ensuring no vendor lock-in.

## 🏗️ Architecture Overview

The repository follows a service-oriented hub-and-spoke inspired structure orchestrated by **Terragrunt**:

```mermaid
graph TB
    subgraph "High Availability Stack"
        LB[Public Load Balancer] --> AGW[App Gateway + WAF]
        AGW --> VMSS[VM Scale Set / Auto-Scaling]
        VMSS --> ILB[Internal Load Balancer]
        ILB --> SQL[(SQL Cluster - Zone Redundant)]
    end
    
    subgraph "Security & Monitoring"
        KV[Key Vault - RBAC Auth]
        LAW[Log Analytics Workspace]
        RSV[Recovery Services Vault]
        Alerts[Metric Alerts / Action Groups]
    end

    subgraph "Governance"
        OPA[OPA/Conftest Policies]
        ID[Managed Identities]
    end
```

## 📂 Project Structure

```text
tf-azure/
├── modules/                  # Granular, reusable infrastructure modules
│   ├── networking/           # {vnet, firewall, lb, app_gateway, peering, route_table}
│   ├── compute/              # {vmss, linux_vm, windows_vm}
│   ├── database/             # {mssql_server, mssql_database}
│   └── security/             # {key_vault, rsv, identities, rbac}
├── environments/             # Terragrunt Grouped Stacks
│   ├── dev/                  # Cost-optimized Development environment
│   └── prod/                 # High-performance, HA Production environment
├── policy/                   # OPA/Rego Infrastructure Policies
└── .github/workflows/        # CI/CD (Lint, Test, Policy, Scan)
```

## 🌍 Environment Differentiation

| Feature | Development (Dev) | Production (Prod) |
|---------|-------------------|-------------------|
| **Networking** | 10.0.0.0/16 | 10.1.0.0/16 |
| **Firewall** | Standard | Premium (IDPS/TLS) |
| **SQL DB** | Basic | S0 (Zone Redundant) |
| **Storage** | LRS | GRS (Geo-Redundant) |
| **Retention** | 30 Days | 90 Days (Audit Ready) |
| **VM Sizing** | Burstable (B-series) | General Purpose (D/DS-series) |

## 🛠️ Quick Start

1. **Clone & Explore:**
   ```bash
   git clone https://github.com/shreyansh-sawarn/tf-azure.git
   cd tf-azure
   ```
2. **Run Tests (No Azure login required):**
   ```bash
   # CI/CD automatically runs these for every module
   terraform -chdir=modules/compute/vmss test
   ```
3. **Plan with Terragrunt:**
   ```bash
   cd environments/dev
   terragrunt run-all plan
   ```

---
*Developed as a professional showcase of Infrastructure as Code (IaC) best practices. Open to collaboration and feedback.*

Made with ❤️ by Shreyansh.
