# 🤖 AI-Driven IaC Drift Detection & Remediation Engine

This folder contains the core script, mock data, and expected outputs for your repository's **AI-driven drift detection and automated remediation engine**. 

Consolidating these files at the root level under `aiops/` turns the AI feature into a first-class citizen of the repository, showcasing automated cloud operations directly alongside standard Terraform modules and environment definitions.

---

## 🏗️ How it Works

The system operates in a two-stage pipeline:
1. **Audit Phase**:
   - Executes a scheduled Terragrunt plan (`terragrunt run-all plan`) comparing the actual cloud state with Git.
   - Evaluates the plan against your Open Policy Agent (OPA) policy rules in `policy/infra_policies.rego`.
2. **AI Reasoning Phase**:
   - Synthesizes the plan changes and policy failures into a compact context payload.
   - Sends it to the **Gemini API** with strict prompt instructions.
   - Generates a beautifully formatted Markdown report containing a plain-English explanation of the drifts, estimated cost impacts, and **dual remediation blueprints** (direct Azure CLI command to *revert*, and Terragrunt inputs to *adopt*).

---

## 📂 Folder Contents

All AI assets are self-contained within this directory:
* **Active Python Scripts**:
  * **[drift_analyzer.py](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/aiops/drift_analyzer.py)**: Audit plan diffs & compliance logs.
  * **[cost_optimizer.py](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/aiops/cost_optimizer.py)**: Advisor for Infracost differentials.
  * **[failure_analyzer.py](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/aiops/failure_analyzer.py)**: Diagnostics for failed apply logs.
  * **[policy_generator.py](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/aiops/policy_generator.py)**: CLI generator of OPA Rego rules.
* **[mock_data/](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/aiops/mock_data)**: Sub-folder containing raw input data:
  * **mock_tfplan.json** / **mock_opa_report.json**: Ingests for drift auditing.
  * **mock_infracost.json**: Ingest for cost optimization.
  * **failed_deploy.log**: Ingest for failure diagnostics.
* **[expected_reports/](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/aiops/expected_reports)**: Sub-folder containing pre-cached Markdown audit summaries for dry-runs and offline fallbacks:
  * **expected_drift_report.md** / **expected_cost_report.md** / **expected_failure_report.md**

---

## 🚀 Running the Local Demo

The analyzer script is built using Python's standard libraries so it requires **zero external dependencies (no pip install required)** and is fully compatible with Windows, macOS, and Linux.

### Option 1: Zero-Config Offline Demo (No API Key Required)
Run any of the tools with the `--demo` flag to execute locally using cached expected reports (no Azure login or LLM credentials required):
```powershell
# 1) Drift & Compliance Audit Demo (generates drift_report.md)
python aiops/drift_analyzer.py --demo

# 2) FinOps Cost Optimizer Demo (generates cost_report.md)
python aiops/cost_optimizer.py --demo

# 3) Deployment Diagnostics Demo (generates failure_report.md)
python aiops/failure_analyzer.py --demo

# 4) Security Threat Modeling Demo (generates security_review.md)
python aiops/security_reviewer.py --demo

# 5) Interactive Copilot Demo (simulated step-through conversation)
python aiops/copilot.py --demo
```
This writes local `.md` report files to your workspace for review.

### Option 2: Live AI Generation (Requires Gemini API Key)
If you have a Gemini API key, you can run the live LLM analysis on the mock data:
```powershell
# Set your API Key
$env:GEMINI_API_KEY="your_api_key_here"

# Execute live LLM analysis:
# 1) Live Drift & Compliance Audit
python aiops/drift_analyzer.py `
  --plan aiops/mock_data/mock_tfplan.json `
  --policy-report aiops/mock_data/mock_opa_report.json `
  --output drift_report_live.md

# 2) Live FinOps Cost Advisor
python aiops/cost_optimizer.py `
  --infracost-json aiops/mock_data/mock_infracost.json `
  --output cost_report_live.md

# 3) Live Deployment Failure Diagnostics
python aiops/failure_analyzer.py `
  --error-log aiops/mock_data/failed_deploy.log `
  --output failure_report_live.md

# 4) Live OPA Policy Generator (creates Rego rule and appends it to rules catalog)
python aiops/policy_generator.py `
  --prompt "Ensure key vaults disable public access"

# 5) Live Security Threat Reviewer
python aiops/security_reviewer.py `
  --plan aiops/mock_data/mock_tfplan.json `
  --output security_report_live.md

# 6) Live Interactive Repository Copilot
python aiops/copilot.py
```

---

## 🛠️ Production CI/CD Deployment

In a production repository, this system is automated using two GitHub Actions workflows:

1. **[aiops-suite-demo.yml](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/.github/workflows/aiops-suite-demo.yml)**:
   - An offline sandbox workflow triggered via `workflow_dispatch` or PRs to demonstrate the workflow actions.
2. **[aiops-live-audit.yml](file:///C:/Users/shrey/OneDrive/Documents/Repos/tf-azure/.github/workflows/aiops-live-audit.yml)**:
   - A production workflow running on a daily schedule (`cron`).
   - Uses **Azure OIDC (OpenID Connect)** to authenticate securely without hardcoded credentials.
   - Runs live Terragrunt plans and OPA audits.
   - If drift is detected:
     * Raises a **GitHub Issue** detailing security and policy violations.
     * Automatically creates a git branch and opens a **Pull Request** containing the HCL patches to adopt the changes back to Git.

### Configuring GitHub Secrets for Live Auditing
To enable the live workflow, add the following secrets/variables to your GitHub Repository:
* `GEMINI_API_KEY`: API Key generated from Google AI Studio.
* `AZURE_CLIENT_ID`: Azure App Client ID.
* `AZURE_TENANT_ID`: Azure Directory Tenant ID.
* `AZURE_SUBSCRIPTION_ID`: Azure target Subscription ID.
