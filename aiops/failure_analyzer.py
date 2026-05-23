#!/usr/bin/env python3
"""
AI IaC Deploy Failure Analyzer (Diagnostics Engine)
Uses the Gemini API to analyze failed Terraform/Terragrunt CLI logs,
translate cryptic ARM API errors, and generate step-by-step troubleshooting actions.
"""

import argparse
import os
import sys
import json
import urllib.request

# Default paths relative to script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MOCK_LOG = os.path.join(SCRIPT_DIR, "mock_data", "failed_deploy.log")
DEFAULT_EXPECTED_FAIL = os.path.join(SCRIPT_DIR, "expected_reports", "expected_failure_report.md")

def parse_args():
    parser = argparse.ArgumentParser(description="AI IaC Failure Diagnostics Engine")
    parser.add_argument("--error-log", help="Path to raw failed deployment CLI log", default=DEFAULT_MOCK_LOG)
    parser.add_argument("--output", help="Path to write the diagnostics report", default="failure_report.md")
    parser.add_argument("--demo", action="store_true", help="Run in offline demo mode using pre-cached responses")
    return parser.parse_args()

def read_log_file(log_path):
    if not os.path.exists(log_path):
        sys.stderr.write(f"Error: Log file '{log_path}' does not exist.\n")
        sys.exit(1)
        
    try:
        with open(log_path, "r", encoding="utf-8") as f:
            # Keep only the last 200 lines to avoid sending huge logs to context window
            lines = f.readlines()
            return "".join(lines[-200:])
    except Exception as e:
        sys.stderr.write(f"Error reading log file: {str(e)}\n")
        sys.exit(1)

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
        print("🤖 Running Failure Analyzer in OFFLINE DEMO mode...")
        if not os.path.exists(DEFAULT_EXPECTED_FAIL):
            sys.stderr.write(f"Error: Pre-cached output file '{DEFAULT_EXPECTED_COST}' not found.\n")
            sys.exit(1)
            
        with open(DEFAULT_EXPECTED_FAIL, "r", encoding="utf-8") as f:
            content = f.read()
            
        with open(args.output, "w", encoding="utf-8") as out_f:
            out_f.write(content)
            
        print(f"✅ Successfully wrote cached diagnostics report to {args.output}")
        sys.exit(0)

    # 2. Live LLM Mode
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("⚠️  GEMINI_API_KEY environment variable not found.")
        print("🔄 Falling back to OFFLINE DEMO mode for Failure Diagnostics.")
        print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
        args.demo = True
        main()
        return

    print("🚨 Ingesting failed deployment log lines...")
    log_content = read_log_file(args.error_log)
    
    print("🧠 Querying Gemini API for deployment diagnostics and fixes...")
    prompt = f"""You are an expert Azure Cloud DevOps and Support Escalation Engineer.
Analyze the following failed Terraform/Terragrunt deployment terminal output and generate a detailed troubleshooting/fix report.

### Failed Deployment Terminal Logs:
```text
{log_content}
```

Please construct the Markdown diagnostics report following these guidelines:
1. Provide an executive summary of the incident (which resource failed to create/update, HTTP status codes, and error codes).
2. Explain the root cause of the error in plain English. Translate cryptic cloud API traces (e.g. explain subscription VM family limits standardDSv2Family standard cores constraints if quota limits are exceeded).
3. Generate a structured step-by-step resolution blueprint showing:
   - Option A: Code-level refactoring. Provide the exact HCL variables change diff to bypass the failure (e.g. downgrading a VM size to standard_B-series).
   - Option B: Platform-level remediation. Provide copy-pasteable Azure CLI or PowerShell commands to adjust cloud configurations (e.g. requesting capacity quota increases).
4. Use clear visual elements like alerts, cost tables, warning notes, and markdown code formatting blocks.
"""

    report_content = call_gemini_api(api_key, prompt)
    
    with open(args.output, "w", encoding="utf-8") as out_f:
        out_f.write(report_content)
    print(f"✅ Successfully wrote live diagnostics report to {args.output}")

if __name__ == "__main__":
    main()
