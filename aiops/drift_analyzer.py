#!/usr/bin/env python3
"""
AI IaC Drift Analyzer & Compliance Engine
Uses the Gemini API to analyze Terraform/Terragrunt drift plans and OPA compliance results,
generating plain-English summaries, Azure CLI revert scripts, and Terragrunt HCL adoption code.
"""

import argparse
import json
import os
import sys
import urllib.request

# Default paths relative to script location (self-contained within aiops/)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MOCK_PLAN = os.path.join(SCRIPT_DIR, "mock_data", "mock_tfplan.json")
DEFAULT_MOCK_OPA = os.path.join(SCRIPT_DIR, "mock_data", "mock_opa_report.json")
DEFAULT_EXPECTED_OUT = os.path.join(SCRIPT_DIR, "expected_output.md")

def parse_args():
    parser = argparse.ArgumentParser(description="AI IaC Drift Analyzer")
    parser.add_argument("--plan", help="Path to Terraform plan JSON file", default=DEFAULT_MOCK_PLAN)
    parser.add_argument("--policy-report", help="Path to OPA conftest violation report (optional JSON)", default=DEFAULT_MOCK_OPA)
    parser.add_argument("--output", help="Path to write the Markdown report", default="drift_report.md")
    parser.add_argument("--output-hcl-patch", help="Path to write the proposed HCL patch variable outputs (optional)")
    parser.add_argument("--demo", action="store_true", help="Run in offline demo mode using pre-cached responses")
    return parser.parse_args()

def extract_drifted_resources(plan_path):
    if not os.path.exists(plan_path):
        sys.stderr.write(f"Error: Plan file '{plan_path}' does not exist.\n")
        sys.exit(1)
        
    try:
        with open(plan_path, "r", encoding="utf-8") as f:
            plan_data = json.load(f)
    except Exception as e:
        sys.stderr.write(f"Error reading plan JSON: {str(e)}\n")
        sys.exit(1)
        
    drifted_resources = []
    
    # Process resource_changes
    resource_changes = plan_data.get("resource_changes", [])
    for rc in resource_changes:
        change = rc.get("change", {})
        actions = change.get("actions", [])
        
        # Check if the resource has been created, deleted, or updated
        if actions and actions != ["no-op"]:
            # Prune out large configuration blocks to save context tokens and ensure clarity
            pruned_before = {}
            pruned_after = {}
            
            before = change.get("before") or {}
            after = change.get("after") or {}
            
            # Find modified properties
            modified_keys = set()
            if isinstance(before, dict) and isinstance(after, dict):
                for k in set(before.keys()).union(after.keys()):
                    if before.get(k) != after.get(k):
                        modified_keys.add(k)
            
            # Keep only the modified properties and standard identifiers (like name, location, size, etc.)
            critical_keys = {"name", "size", "location", "tags", "public_network_access_enabled", "container_access_type"}
            keys_to_keep = modified_keys.union(critical_keys)
            
            if isinstance(before, dict):
                pruned_before = {k: v for k, v in before.items() if k in keys_to_keep}
            else:
                pruned_before = before
                
            if isinstance(after, dict):
                pruned_after = {k: v for k, v in after.items() if k in keys_to_keep}
            else:
                pruned_after = after

            drifted_resources.append({
                "address": rc.get("address"),
                "type": rc.get("type"),
                "name": rc.get("name"),
                "actions": actions,
                "before": pruned_before,
                "after": pruned_after
            })
            
    return drifted_resources

def extract_policy_failures(report_path):
    if not report_path or not os.path.exists(report_path):
        return []
        
    try:
        with open(report_path, "r", encoding="utf-8") as f:
            report_data = json.load(f)
    except Exception as e:
        sys.stderr.write(f"Warning: Failed to read policy report JSON: {str(e)}\n")
        return []
        
    policy_failures = []
    
    # Support Conftest JSON structure
    if isinstance(report_data, list):
        for item in report_data:
            if isinstance(item, dict):
                # Standard conftest outputs failures in list
                failures = item.get("failures", [])
                if isinstance(failures, list):
                    for fail in failures:
                        if isinstance(fail, dict) and "msg" in fail:
                            policy_failures.append(fail["msg"])
                        elif isinstance(fail, str):
                            policy_failures.append(fail)
                elif "msg" in item:
                    policy_failures.append(item["msg"])
            elif isinstance(item, str):
                policy_failures.append(item)
                
    return policy_failures

def call_gemini_api(api_key, prompt):
    # Standard endpoint for Gemini API
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
        sys.stderr.write(f"Error executing Gemini API request: {str(e)}\n")
        sys.exit(1)

def generate_hcl_patch(api_key, drifted_resources):
    prompt = f"""You are an expert Terraform/Terragrunt engineer.
Given the following drifted resources:
{json.dumps(drifted_resources, indent=2)}

Generate ONLY a block of Terragrunt input values representing the changes to adopt.
Format the output as a valid block of Terragrunt HCL inputs.
Include comments specifying which file is targeted.
Do not wrap in a markdown code block. Return ONLY raw HCL code content.
"""
    return call_gemini_api(api_key, prompt)

def main():
    # Configure UTF-8 encoding for stdout/stderr to support emojis on Windows terminals
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")

    args = parse_args()
    
    # 1. Check for Demo mode
    if args.demo:
        print("🤖 Running in OFFLINE DEMO mode...")
        if not os.path.exists(DEFAULT_EXPECTED_OUT):
            sys.stderr.write(f"Error: Pre-cached output file '{DEFAULT_EXPECTED_OUT}' not found.\n")
            sys.exit(1)
            
        with open(DEFAULT_EXPECTED_OUT, "r", encoding="utf-8") as f:
            content = f.read()
            
        with open(args.output, "w", encoding="utf-8") as out_f:
            out_f.write(content)
            
        print(f"✅ Successfully wrote cached report to {args.output}")
        
        if args.output_hcl_patch:
            sample_hcl = (
                "# Adopt patch generated automatically\n"
                "inputs = {\n"
                "  vm_size = \"Standard_D4s_v3\"\n"
                "  public_network_access_enabled = true\n"
                "}\n"
            )
            with open(args.output_hcl_patch, "w", encoding="utf-8") as patch_f:
                patch_f.write(sample_hcl)
            print(f"✅ Successfully wrote cached HCL patch to {args.output_hcl_patch}")
            
        sys.exit(0)

    # 2. Live LLM Generation Mode
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("⚠️  GEMINI_API_KEY environment variable not found.")
        print("🔄 Falling back to OFFLINE DEMO mode using pre-cached responses.")
        print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
        args.demo = True
        main()
        return

    print("🔍 Analyzing plan diff files and policy violations...")
    drifted = extract_drifted_resources(args.plan)
    policy_fails = extract_policy_failures(args.policy_report)
    
    if not drifted:
        print("✅ No infrastructure drift detected in plan file.")
        # Create a simple clean report
        with open(args.output, "w", encoding="utf-8") as f:
            f.write("# 🤖 AI IaC Drift Detection & Compliance Analysis Report\n\n✅ **Status: CLEAN** - No infrastructure drift detected.")
        sys.exit(0)
        
    print(f"📝 Found {len(drifted)} drifted resources and {len(policy_fails)} policy failures.")
    print("🧠 Querying Gemini API for remediation assessment...")

    prompt = f"""You are an expert Azure Cloud Architect and DevSecOps Engineer.
Analyze the following infrastructure drift and OPA policy violation reports, and generate a detailed, professional, and visually stunning Markdown remediation report.

### Live Infrastructure Drift (from terraform plan):
{json.dumps(drifted, indent=2)}

### OPA Policy Failures:
{json.dumps(policy_fails, indent=2)}

Please construct the Markdown report following these strict guidelines:
1. Include an executive summary highlighting the total count of drifted resources, policy violations, and high-level severity categories.
2. For each drifted resource:
   - Describe what changed (from -> to values).
   - Map it to any associated OPA policy failures and explain the technical risk (e.g. security exposure, cost overrun).
   - Provide a precise Azure CLI command to REVERT the change in the cloud.
   - Provide a clean HCL variables block to ADOPT the change into the local Terragrunt configuration.
3. Keep the output clean, using standard markdown formatting, tables, warnings, and code blocks.
"""

    report_content = call_gemini_api(api_key, prompt)
    
    with open(args.output, "w", encoding="utf-8") as out_f:
        out_f.write(report_content)
    print(f"✅ Successfully wrote live AI analysis report to {args.output}")

    if args.output_hcl_patch:
        print("🧩 Generating HCL variables block for code adoption...")
        hcl_patch = generate_hcl_patch(api_key, drifted)
        with open(args.output_hcl_patch, "w", encoding="utf-8") as patch_f:
            patch_f.write(hcl_patch)
        print(f"✅ Successfully wrote live HCL patch to {args.output_hcl_patch}")

if __name__ == "__main__":
    main()
