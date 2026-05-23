#!/usr/bin/env python3
"""
Interactive AIOps CLI Copilot
Pre-loads local repository metadata (modules, variable inputs, OPA policy rules)
and launches a conversational chat session utilizing Gemini to assist engineers.
"""

import argparse
import os
import sys
import json
import urllib.request

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)
DEFAULT_POLICY_PATH = os.path.join(REPO_ROOT, "policy", "infra_policies.rego")

def parse_args():
    parser = argparse.ArgumentParser(description="Interactive AIOps CLI Copilot")
    parser.add_argument("--demo", action="store_true", help="Run in step-through offline demo mode")
    return parser.parse_args()

def scan_repo():
    modules = []
    modules_dir = os.path.join(REPO_ROOT, "modules")
    if os.path.exists(modules_dir):
        try:
            for category in os.listdir(modules_dir):
                cat_path = os.path.join(modules_dir, category)
                if os.path.isdir(cat_path):
                    for mod in os.listdir(cat_path):
                        mod_path = os.path.join(cat_path, mod)
                        if os.path.isdir(mod_path):
                            modules.append(f"modules/{category}/{mod}")
        except Exception as e:
            sys.stderr.write(f"Warning: Failed to scan modules folder: {str(e)}\n")
            
    policies = []
    if os.path.exists(DEFAULT_POLICY_PATH):
        try:
            with open(DEFAULT_POLICY_PATH, "r", encoding="utf-8") as f:
                for line in f:
                    if line.startswith("#") and len(line.strip()) > 3:
                        policies.append(line.strip("# \n"))
        except Exception as e:
            sys.stderr.write(f"Warning: Failed to parse OPA policies: {str(e)}\n")
            
    return modules, policies

def call_gemini_chat(api_key, history, system_instruction):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    headers = {"Content-Type": "application/json"}
    
    payload = {
        "contents": history,
        "systemInstruction": {
            "parts": [{"text": system_instruction}]
        }
    }
    
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST"
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            res_data = json.loads(response.read().decode("utf-8"))
            return res_data["candidates"][0]["content"]["parts"][0]["text"]
    except Exception as e:
        sys.stderr.write(f"\nError contacting Gemini: {str(e)}\n")
        return None

def run_offline_demo():
    print("\n" + "="*60)
    print("🤖 Welcome to the tf-azure AIOps Copilot [OFFLINE DEMO MODE]")
    print("Pre-loaded context: 14 modules, 8 OPA policies")
    print("Press [ENTER] to step through the simulated developer interaction.")
    print("="*60 + "\n")
    
    # Dialogue 1
    input("[Developer]: How do I instantiate a storage account for dev and what OPA rules apply? [Press Enter]")
    print("\n🤖 [Copilot]:")
    print("To declare a storage account in the development environment, add this block to your")
    print("`environments/dev/foundation/terragrunt.hcl` inputs:")
    print("```hcl")
    print("inputs = {")
    print("  storage_accounts = {")
    print("    dev_logs = {")
    print("      name                     = \"devtflogs\"")
    print("      account_tier             = \"Standard\"")
    print("      account_replication_type = \"LRS\" # Cost optimized for Dev")
    print("      public_network_access_enabled = false # Satisfies OPA Rule #3")
    print("      https_traffic_only_enabled    = true  # Satisfies OPA Rule #7")
    print("      tags = {")
    print("        Environment = \"Dev\"      # Satisfies OPA Rule #1")
    print("        Project     = \"tf-azure\" # Satisfies OPA Rule #1")
    print("      }")
    print("    }")
    print("  }")
    print("}")
    print("```")
    print("⚠️ **Active OPA Governance Constraints Checked:**")
    print("* **Rule #1 (Mandatory Tags)**: Requires both `Environment` and `Project` tags.")
    print("* **Rule #3 (Public Access)**: Public access must be disabled (`public_network_access_enabled = false`).")
    print("* **Rule #7 (Enforce HTTPS)**: HTTPS traffic only must be enabled.")
    print("\n" + "-"*60 + "\n")
    
    # Dialogue 2
    input("[Developer]: Can you write the inputs HCL for a Linux VM scale set using our compute module? [Press Enter]")
    print("\n🤖 [Copilot]:")
    print("Here is the HCL input variables block mapped specifically to the interface parameters of your")
    print("`modules/compute/vmss` module. Declare this in your `environments/dev/compute/terragrunt.hcl`:")
    print("```hcl")
    print("terraform {")
    print("  source = \"../../../modules/compute/vmss\"")
    print("}")
    print("\ninputs = {")
    print("  vmss_name      = \"dev-app-scale-set\"")
    print("  vm_size        = \"Standard_B2s\" # Optimized B-Series VM satisfying Dev OPA Rule #8")
    print("  instances_count = 2")
    print("  admin_username  = \"azureuser\"")
    print("  disable_password_authentication = true # Enforces SSH authentication (OPA Rule #6)")
    print("  ")
    print("  # Network integration")
    print("  subnet_id = dependency.networking.outputs.app_subnet_id")
    print("  ")
    print("  tags = {")
    print("    Environment = \"Dev\"")
    print("    Project     = \"tf-azure\"")
    print("  }")
    print("}")
    print("```")
    print("⚠️ **Active OPA Governance Constraints Checked:**")
    print("* **Rule #6 (Password Auth)**: Direct password login is disabled; SSH authentication is enforced.")
    print("* **Rule #8 (Dev VM Sizing)**: Size is limited to standard non-prod burstable SKUs (`Standard_B2s` chosen).")
    print("\n" + "="*60)
    print("👋 [Demo Mode Complete] To chat live, set GEMINI_API_KEY and run without the --demo flag.")
    print("="*60 + "\n")

def main():
    # Force UTF-8 on Windows
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")

    args = parse_args()
    
    api_key = os.environ.get("GEMINI_API_KEY")
    if args.demo or not api_key:
        if not api_key and not args.demo:
            print("⚠️  GEMINI_API_KEY not found. Falling back to offline demonstration mode...")
        run_offline_demo()
        sys.exit(0)
        
    print("🔍 Scanning local repository layout and OPA policies...")
    modules, policies = scan_repo()
    
    system_instruction = f"""You are the Interactive Developer Copilot for the 'tf-azure' infrastructure repository.
You assist developers in writing Terraform/Terragrunt code, aligning with governance, and understanding modules.

Here is the context of the repository you are running in:
- **Available Custom Modules**:
{json.dumps(modules, indent=2)}

- **Active OPA Security & Cost Policy Rules**:
{json.dumps(policies, indent=2)}

Guidelines:
1. Always structure HCL variables outputs to match the inputs structure of Terragrunt or Terraform.
2. If code recommendations are asked, remind the developer of OPA policy guidelines that apply to that resource (e.g. tagging rules, VM sizing policies, public endpoint blocks).
3. Keep responses concise, using clean formatting, bulletins, and markdown code blocks.
"""

    print("\n" + "="*60)
    print("🤖 Welcome to the tf-azure AIOps Copilot [LIVE INTERACTIVE MODE]")
    print(f"Pre-loaded: {len(modules)} modules, {len(policies)} OPA rules")
    print("Type 'exit' or 'quit' to close the chat.")
    print("="*60 + "\n")
    
    history = []
    
    while True:
        try:
            user_msg = input("[Developer]: ")
        except (KeyboardInterrupt, EOFError):
            print("\n👋 Goodbye!")
            break
            
        if user_msg.strip().lower() in ["exit", "quit"]:
            print("👋 Goodbye!")
            break
            
        if not user_msg.strip():
            continue
            
        # Append message to history
        history.append({
            "role": "user",
            "parts": [{"text": user_msg}]
        })
        
        sys.stdout.write("🤖 [Copilot is thinking]...")
        sys.stdout.flush()
        
        response = call_gemini_chat(api_key, history, system_instruction)
        
        # Erase the thinking message
        sys.stdout.write("\r" + " " * 30 + "\r")
        sys.stdout.flush()
        
        if response:
            print(f"🤖 [Copilot]:\n{response}\n" + "-"*60 + "\n")
            # Append model response to chat history
            history.append({
                "role": "model",
                "parts": [{"text": response}]
            })
        else:
            print("🤖 [Copilot]: Sorry, I encountered an error communicating with the API. Please try again.\n")
            # Pop the last user message if the request failed to keep conversation sync
            history.pop()

if __name__ == "__main__":
    main()
