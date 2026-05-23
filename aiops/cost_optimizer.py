#!/usr/bin/env python3
"""
AI IaC Cost Optimizer (FinOps Engine)
Uses the Gemini API to analyze Infracost cost changes, identify waste,
and suggest cost-saving refactoring modifications for Azure environments.
"""

import argparse
import json
import os
import sys
import urllib.request

# Default paths relative to script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MOCK_COST = os.path.join(SCRIPT_DIR, "mock_data", "mock_infracost.json")
DEFAULT_EXPECTED_COST = os.path.join(SCRIPT_DIR, "expected_reports", "expected_cost_report.md")

def parse_args():
    parser = argparse.ArgumentParser(description="AI IaC Cost Optimizer")
    parser.add_argument("--infracost-json", help="Path to Infracost JSON breakdown", default=DEFAULT_MOCK_COST)
    parser.add_argument("--output", help="Path to write the FinOps report", default="cost_report.md")
    parser.add_argument("--demo", action="store_true", help="Run in offline demo mode using pre-cached responses")
    return parser.parse_args()

def parse_infracost_diff(infracost_path):
    if not os.path.exists(infracost_path):
        sys.stderr.write(f"Error: Infracost file '{infracost_path}' does not exist.\n")
        sys.exit(1)
        
    try:
        with open(infracost_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        sys.stderr.write(f"Error reading Infracost JSON: {str(e)}\n")
        sys.exit(1)
        
    summary = {
        "totalMonthlyCost": data.get("totalMonthlyCost"),
        "pastTotalMonthlyCost": data.get("pastTotalMonthlyCost"),
        "diffTotalMonthlyCost": data.get("diffTotalMonthlyCost"),
        "currency": data.get("currency", "USD"),
        "projects": []
    }
    
    projects = data.get("projects", [])
    for proj in projects:
        proj_summary = {
            "name": proj.get("name"),
            "cost_increases": []
        }
        
        # Analyze diff resources
        diff_resources = proj.get("diff", {}).get("resources", [])
        for res in diff_resources:
            cost_change = float(res.get("monthlyCost", 0))
            if cost_change > 0:
                cost_components = []
                for comp in res.get("costComponents", []):
                    cost_components.append({
                        "name": comp.get("name"),
                        "monthlyCost": comp.get("monthlyCost")
                    })
                proj_summary["cost_increases"].append({
                    "name": res.get("name"),
                    "monthlyCost": res.get("monthlyCost"),
                    "costComponents": cost_components
                })
        summary["projects"].append(proj_summary)
        
    return summary

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
        print("🤖 Running Cost Optimizer in OFFLINE DEMO mode...")
        if not os.path.exists(DEFAULT_EXPECTED_COST):
            sys.stderr.write(f"Error: Pre-cached output file '{DEFAULT_EXPECTED_COST}' not found.\n")
            sys.exit(1)
            
        with open(DEFAULT_EXPECTED_COST, "r", encoding="utf-8") as f:
            content = f.read()
            
        with open(args.output, "w", encoding="utf-8") as out_f:
            out_f.write(content)
            
        print(f"✅ Successfully wrote cached cost report to {args.output}")
        sys.exit(0)

    # 2. Live LLM Mode
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("⚠️  GEMINI_API_KEY environment variable not found.")
        print("🔄 Falling back to OFFLINE DEMO mode for Cost Optimization.")
        print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
        args.demo = True
        main()
        return

    print("📊 Parsing Infracost cost changes...")
    cost_summary = parse_infracost_diff(args.infracost_json)
    
    print("🧠 Ingesting cost data and querying Gemini FinOps assistant...")
    prompt = f"""You are a professional FinOps (Cloud Financial Operations) and Azure Infrastructure Architect.
Analyze the following Infracost change summary and generate a detailed cost-reduction and optimization review.

### Proposed Cost Changes:
{json.dumps(cost_summary, indent=2)}

Please construct the Markdown report following these guidelines:
1. Include an executive table detailing Previous Monthly Spend, New Monthly Spend, and Net Cost Change (and percentage change).
2. Detail the exact resource additions or modifications causing the highest budget increases.
3. Formulate concrete cost-saving recommendations tailored specifically for a non-production/development environment context.
   - Suggest downgrading oversized VMs to equivalent burstable tiers (like Standard_B-series).
   - Suggest disabling high-availability SLAs (like SQL Zone Redundancy) if not required in dev.
4. Provide clear Terraform / Terragrunt HCL code diff blocks showing the recommended variables updates.
5. Use clean formatting, cost tables, warning notes, and markdown headers.
"""

    report_content = call_gemini_api(api_key, prompt)
    
    with open(args.output, "w", encoding="utf-8") as out_f:
        out_f.write(report_content)
    print(f"✅ Successfully wrote live FinOps cost report to {args.output}")

if __name__ == "__main__":
    main()
