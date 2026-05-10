# tf-azure: Enterprise-Grade Azure Terraform Templates

A comprehensive, modular, and highly available Terraform template repository for provisioning Microsoft Azure infrastructure. Designed for scalability, security, and professional portfolio demonstration.

## 🚀 Key Features
- **Modular Architecture:** Reusable modules for Networking, Compute, Storage, Databases, Security, and Integration.
- **High Availability:** Built-in support for Availability Sets, GRS/ZRS storage, and resilient service plans.
- **Security First:** Integration with Azure Key Vault, Managed Identities, and Azure Firewall.
- **Environment Management:** Clear separation between `dev` and `prod` environments.
- **Automation Ready:** Standardized naming conventions, clean parameterization, and **Terragrunt** orchestration for DRY, multi-environment deployments.

## 🏗️ Architecture Overview
The repository follows a hub-and-spoke inspired modular structure orchestrated by **Terragrunt**:
- **Networking:** VNET, Subnets, NSGs, and Azure Firewall.
- **Compute:** Linux VMs with High Availability.
- **Web Services:** Azure App Service and serverless Function Apps.
- **Data:** Azure SQL Database and Geo-Redundant Storage.
- **Security:** Centralized secret management with Azure Key Vault.
- **Integration:** Asynchronous messaging with Service Bus and Logic Apps.

## 📂 Project Structure
```text
tf-azure/
├── modules/                  # Reusable resource modules
│   ├── networking/           # VNET, Subnets, NSGs, Firewall
│   ├── compute/              # Virtual Machines, Availability Sets
│   ├── database/             # Azure SQL
│   ├── security/             # Key Vault
│   ├── storage/              # Storage Accounts
│   ├── integration/          # Service Bus, Logic Apps
│   └── web/                  # App Service, Function App
├── environments/             # Environment-specific orchestration
│   ├── terragrunt.hcl        # Root Terragrunt config (DRY providers/state)
│   ├── dev/                  # Development environment
│   │   ├── env.hcl           # Environment-specific variables
│   │   ├── networking/       # Component-level Terragrunt config
│   │   └── ...
│   └── prod/                 # Production environment (template)
├── DESIGN.md                 # Project architecture and design goals
└── TERRAFORM_GUIDE.md        # Usage and deployment instructions
```

## 🛠️ Getting Started
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/tf-azure.git
   cd tf-azure
   ```
2. **Configure your environment:**
   Update `environments/dev/env.hcl` with your project details.
3. **Initialize and Plan (All Components):**
   ```bash
   cd environments/dev
   terragrunt run-all plan
   ```

## 📝 Portfolio Note
This repository uses **Terragrunt** to showcase advanced IaC orchestration patterns, including remote state management, dependency injection, and DRY configuration management.

---
*Developed as a professional showcase of Infrastructure as Code (IaC) best practices on Azure.*
