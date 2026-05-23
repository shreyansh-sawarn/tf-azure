#!/usr/bin/env python3
"""
AI IaC Security Reviewer (Threat Modeler)
Uses the Gemini API to analyze planned Terraform changes,
perform a STRIDE threat modeling review, and suggest mitigations.
"""

import argparse
import json
import os
import sys
import urllib.request

# Default paths relative to script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MOCK_PLAN = os.path.join(SCRIPT_DIR, "mock_data", "mock_tfplan.json")
DEFAULT_EXPECTED_SEC = os.path.join(SCRIPT_DIR, "expected_reports", "expected_security_report.md")

def parse_args():
    parser = argparse.ArgumentParser(description="AI IaC Security Reviewer")
    parser.add_argument("--plan", help="Path to Terraform plan JSON file", default=DEFAULT_MOCK_PLAN)
    parser.add_argument("--output", help="Path to write the Security report", default="security_review.md")
    parser.add_argument("--demo", action="store_true", help="Run in offline demo mode using pre-cached responses")
    return parser.parse_args()

def extract_plan_changes(plan_path):
    if not os.path.exists(plan_path):
        sys.stderr.write(f"Error: Plan file '{plan_path}' does not exist.\n")
        sys.exit(1)
        
    try:
        with open(plan_path, "r", encoding="utf-8") as f:
            plan_data = json.load(f)
    except Exception as e:
        sys.stderr.write(f"Error reading plan JSON: {str(e)}\n")
        sys.exit(1)
        
    changes = []
    
    resource_changes = plan_data.get("resource_changes", [])
    for rc in resource_changes:
        change = rc.get("change", {})
        actions = change.get("actions", [])
        
        if actions and actions != ["no-op"]:
            changes.append({
                "address": rc.get("address"),
                "type": rc.get("type"),
                "name": rc.get("name"),
                "actions": actions,
                "before": change.get("before"),
                "after": change.get("after")
            })
            
    return changes

def call_gemini_api(api_key, prompt):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    headers = {"Content-Type": "application/json"}
    
    payload = {
        "contents": [{
            "parts": [{
                "text": prompt
            }]
        }]
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
        sys.stderr.write(f"Error calling Gemini API: {str(e)}\n")
        sys.exit(1)

def main():
    # Configure UTF-8 encoding for stdout/stderr to support emojis on Windows terminals
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")

    args = parse_args()
    
    # 1. Check for Demo mode
    if args.demo:
        print("🤖 Running Security Reviewer in OFFLINE DEMO mode...")
        if not os.path.exists(DEFAULT_EXPECTED_SEC):
            sys.stderr.write(f"Error: Pre-cached output file '{DEFAULT_EXPECTED_SEC}' not found.\n")
            sys.exit(1)
            
        with open(DEFAULT_EXPECTED_SEC, "r", encoding="utf-8") as f:
            content = f.read()
            
        with open(args.output, "w", encoding="utf-8") as out_f:
            out_f.write(content)
            
        print(f"✅ Successfully wrote cached security report to {args.output}")
        sys.exit(0)

    # 2. Live LLM Mode
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("⚠️  GEMINI_API_KEY environment variable not found.")
        print("🔄 Falling back to OFFLINE DEMO mode for Security Review.")
        print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
        args.demo = True
        main()
        return

    print("🛡️  Parsing plan resource changes...")
    plan_changes = extract_plan_changes(args.plan)
    
    if not plan_changes:
        print("✅ No modifications detected. Security status: CLEAN.")
        with open(args.output, "w", encoding="utf-8") as f:
            f.write("# 🛡️ AI Cloud Security Threat Modeling & Design Review\n\n✅ **Status: CLEAN** - No resource changes to evaluate.")
        sys.exit(0)

    print("🧠 Querying Gemini for security threat modeling evaluation...")
    prompt = f"""You are a professional Cloud Security Architect and SecOps Audit Consultant.
Analyze the following planned infrastructure changes and generate a detailed Security Threat Modeling and Design Review.

### Planned Infrastructure Modifications:
{json.dumps(plan_changes, indent=2)}

Please construct the Markdown threat modeling report following these guidelines:
1. Use the STRIDE Threat Framework (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) to classify risks.
2. Provide a summary table detailing threat categories, severity, resources affected, and short risk descriptions.
3. For each identified vulnerability:
   - Identify the affected resource address.
   - Describe the security exposure and why it is a critical threat vector in cloud networking/infrastructure.
   - Generate exact copy-pasteable Azure CLI commands to secure or REVERT the configuration in the cloud.
   - Generate exact HCL code configuration recommendations to align the git codebase with safety defaults.
4. Conclude with high-level structural security suggestions (such as enforcing private endpoints, identity RBAC locks, or audit configurations).
"""

    report_content = call_gemini_api(api_key, prompt)
    
    with open(args.output, "w", encoding="utf-8") as out_f:
        out_f.write(report_content)
    print(f"✅ Successfully wrote live security report to {args.output}")

if __name__ == "__main__":
    main()
