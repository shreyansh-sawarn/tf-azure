#!/usr/bin/env python3
"""
AI OPA Rego Policy Generator
Uses the Gemini API to translate plain-English security/compliance requirements
into active Open Policy Agent (OPA) Rego rules, appending them directly to your policies.
"""

import argparse
import os
import sys
import json
import urllib.request

# Default paths relative to script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)
DEFAULT_POLICY_FILE = os.path.join(REPO_ROOT, "policy", "infra_policies.rego")

def parse_args():
    parser = argparse.ArgumentParser(description="AI OPA Rego Rule Generator")
    parser.add_argument("--prompt", help="The security rule requirement in plain English", required=True)
    parser.add_argument("--policy-file", help="Path to your OPA rego rules file", default=DEFAULT_POLICY_FILE)
    parser.add_argument("--demo", action="store_true", help="Run in offline demo mode using pre-cached responses")
    return parser.parse_args()

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
        print("🤖 Running OPA Policy Generator in OFFLINE DEMO mode...")
        print(f"📝 Prompt input: '{args.prompt}'")
        
        sample_rego = (
            "\n# AI-Generated Policy: Enforce HTTPS traffic only for Storage Accounts\n"
            "deny[msg] {\n"
            "    resource := input.resource_changes[_]\n"
            "    resource.mode == \"managed\"\n"
            "    resource.type == \"azurerm_storage_account\"\n"
            "    resource.change.after.https_traffic_only_enabled == false\n"
            "    msg := sprintf(\"Storage Account %v must have HTTPS traffic only enabled\", [resource.address])\n"
            "}\n"
        )
        
        print("\n🛠️  Generated OPA Rego Rule:")
        print("---------------------------------------------------")
        print(sample_rego.strip())
        print("---------------------------------------------------")
        print(f"✅ [Demo Mode] Rego rule generated. (In live mode, this appends to {args.policy_file})")
        sys.exit(0)

    # 2. Live LLM Mode
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("⚠️  GEMINI_API_KEY environment variable not found.")
        print("🔄 Falling back to OFFLINE DEMO mode for OPA policy generation.")
        print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
        args.demo = True
        main()
        return

    if not os.path.exists(args.policy_file):
        sys.stderr.write(f"Error: Policy file '{args.policy_file}' does not exist. Cannot append.\n")
        sys.exit(1)
        
    try:
        with open(args.policy_file, "r", encoding="utf-8") as f:
            existing_rego = f.read()
    except Exception as e:
        sys.stderr.write(f"Error reading policy file: {str(e)}\n")
        sys.exit(1)

    print("🛡️  Analyzing existing Rego policies for style and structure...")
    print("🧠 Querying Gemini API to write custom OPA policy rule...")
    
    prompt = f"""You are an expert Open Policy Agent (OPA) developer and SecOps compliance engineer.
You are tasked with writing a new Rego policy rule. The rule must match the structure and style of your existing rule catalog.

### Existing Rego File Content:
```rego
{existing_rego}
```

### New Policy Requirement (Plain English):
"{args.prompt}"

Please generate the rule. Follow these strict formatting rules:
1. Provide a single comment at the top explaining the rule.
2. Structure it as a deny rule block: `deny[msg] {{ ... }}`.
3. Keep the logic consistent with how resource_changes are filtered in the existing code (`resource := input.resource_changes[_]`, checking mode and type, comparing changes in `after`).
4. Output ONLY the raw Rego code. Do not wrap in markdown code blocks. Return only the code block.
"""

    generated_rule = call_gemini_api(api_key, prompt)
    
    # Strip any markdown code formatting wrapper if the model returned it anyway
    clean_rule = generated_rule.strip()
    if clean_rule.startswith("```rego"):
        clean_rule = clean_rule[7:]
    if clean_rule.startswith("```"):
        clean_rule = clean_rule[3:]
    if clean_rule.endswith("```"):
        clean_rule = clean_rule[:-3]
    clean_rule = clean_rule.strip()

    # Append to policy file
    try:
        with open(args.policy_file, "a", encoding="utf-8") as f:
            f.write(f"\n\n# AI-Generated Policy Rule: {args.prompt}\n{clean_rule}\n")
        print(f"✅ Successfully generated and appended new OPA policy rule to {args.policy_file}")
        print("\nGenerated Block:")
        print("---------------------------------------------------")
        print(clean_rule)
        print("---------------------------------------------------")
    except Exception as e:
        sys.stderr.write(f"Error writing to OPA file: {str(e)}\n")
        sys.exit(1)

if __name__ == "__main__":
    main()
