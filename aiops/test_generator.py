#!/usr/bin/env python3
"""
AI Terraform Test Case Generator
Uses the Gemini API to analyze Terraform variable definitions
and automatically write native unit test blocks (.tftest.hcl) with validations.
"""

import argparse
import os
import sys
import json
import urllib.request

# Default paths relative to script location
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_VARIABLES = os.path.join(SCRIPT_DIR, "mock_data", "mock_variables.tf")
DEFAULT_EXPECTED_TEST = os.path.join(SCRIPT_DIR, "expected_reports", "expected_tftest.hcl")

def parse_args():
    parser = argparse.ArgumentParser(description="AI Terraform Unit Test Generator")
    parser.add_argument("--variables-file", help="Path to input variables HCL file", default=DEFAULT_VARIABLES)
    parser.add_argument("--output", help="Path to write the tftest.hcl output file", default="generated.tftest.hcl")
    parser.add_argument("--demo", action="store_true", help="Run in offline demo mode using pre-cached responses")
    parser.add_argument("--scan-modules", action="store_true", help="Scan the modules/ directory and generate unit.tftest.hcl files for each module")
    parser.add_argument("--module", help="Name of a specific module to generate tests for (automatically resolves paths inside modules/)")
    parser.add_argument("--force", action="store_true", help="Force overwrite of existing test files if they already exist")
    return parser.parse_args()

def read_hcl_file(file_path):
    if not os.path.exists(file_path):
        sys.stderr.write(f"Error: Variables file '{file_path}' does not exist.\n")
        sys.exit(1)
        
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return f.read()
    except Exception as e:
        sys.stderr.write(f"Error reading variables file: {str(e)}\n")
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

def scan_and_generate_modules(args, api_key):
    # Modules directory is at root: C:\...\tf-azure\modules
    modules_dir = os.path.abspath(os.path.join(os.path.dirname(SCRIPT_DIR), "modules"))
    if not os.path.exists(modules_dir):
        sys.stderr.write(f"Error: Modules directory '{modules_dir}' not found.\n")
        sys.exit(1)
        
    print(f"🔍 Scanning modules directory: {modules_dir}")
    try:
        subdirs = [d for d in os.listdir(modules_dir) if os.path.isdir(os.path.join(modules_dir, d))]
    except Exception as e:
        sys.stderr.write(f"Error scanning modules directory: {str(e)}\n")
        sys.exit(1)
        
    generated_count = 0
    for subdir in subdirs:
        mod_path = os.path.join(modules_dir, subdir)
        vars_file = os.path.join(mod_path, "variables.tf")
        if os.path.exists(vars_file):
            tests_dir = os.path.join(mod_path, "tests")
            output_file = os.path.join(tests_dir, "unit.tftest.hcl")
            
            # Check for existing test file to prevent overwriting manual work
            if os.path.exists(output_file) and not args.force:
                print(f"⚠️  Skipping module '{subdir}': '{output_file}' already exists. Use --force to overwrite.")
                continue

            print(f"📦 Found module '{subdir}' with variables.tf")
            
            # Ensure tests directory exists
            try:
                os.makedirs(tests_dir, exist_ok=True)
            except Exception as e:
                sys.stderr.write(f"   ⚠️ Could not create tests directory: {str(e)}\n")
                continue
            
            if args.demo:
                # In demo mode, copy/write expected mock test
                # If it's the compute module, use expected_tftest.hcl. Otherwise write a generic mock template
                if subdir == "compute":
                    try:
                        with open(DEFAULT_EXPECTED_TEST, "r", encoding="utf-8") as f:
                            content = f.read()
                    except Exception as e:
                        sys.stderr.write(f"   ⚠️ Error reading expected test: {str(e)}\n")
                        continue
                else:
                    content = f"""# Mock compliance tests for module: {subdir}
# Generated in offline demo mode

mock_provider "azurerm" {{}}

variables {{
  # Default test variables for {subdir}
}}

run "validate_compliance" {{
  command = plan

  assert {{
    condition     = true
    error_message = "Compliance policy validation placeholder for {subdir}"
  }}
}}
"""
                try:
                    with open(output_file, "w", encoding="utf-8") as out_f:
                        out_f.write(content)
                    print(f"   ✅ Written cached/mock test to {output_file}")
                    generated_count += 1
                except Exception as e:
                    sys.stderr.write(f"   ⚠️ Error writing to {output_file}: {str(e)}\n")
            else:
                # Live mode
                print(f"   🧠 Querying Gemini for unit test case generation for '{subdir}'...")
                try:
                    hcl_variables = read_hcl_file(vars_file)
                except Exception as e:
                    sys.stderr.write(f"   ⚠️ Error reading variables file: {str(e)}\n")
                    continue
                    
                prompt = f"""You are an expert Terraform quality control and compliance test engineer.
You are tasked with writing native unit test blocks (.tftest.hcl) validating that module inputs conform to security and sizing guidelines.

### Variable Definitions (HCL) for Module '{subdir}':
```hcl
{hcl_variables}
```

Please generate the `.tftest.hcl` file. Follow these strict guidelines:
1. Include a mock_provider block: `mock_provider "azurerm" {{}}`.
2. Define a default variables block declaring standard test parameters.
3. Write multiple `run` test blocks (e.g. command = plan) that evaluate the variables.
4. For each run block, define at least one `assert` block validating input compliance.
5. Include helpful `error_message` strings.
6. Return ONLY the raw HCL code. Do not wrap in markdown code blocks. Start output directly with HCL comments.
"""
                try:
                    generated_test = call_gemini_api(api_key, prompt)
                except Exception as e:
                    sys.stderr.write(f"   ⚠️ Error calling Gemini: {str(e)}\n")
                    continue
                
                # Clean output wrappers
                clean_test = generated_test.strip()
                if clean_test.startswith("```hcl"):
                    clean_test = clean_test[6:]
                elif clean_test.startswith("```terraform"):
                    clean_test = clean_test[12:]
                if clean_test.startswith("```"):
                    clean_test = clean_test[3:]
                if clean_test.endswith("```"):
                    clean_test = clean_test[:-3]
                clean_test = clean_test.strip()
                
                try:
                    with open(output_file, "w", encoding="utf-8") as out_f:
                        out_f.write(clean_test)
                    print(f"   ✅ Written live test to {output_file}")
                    generated_count += 1
                except Exception as e:
                    sys.stderr.write(f"   ⚠️ Error writing to {output_file}: {str(e)}\n")
                
    print(f"\n🎉 Completed scanning! Generated unit tests for {generated_count} module(s).")

def main():
    # Configure UTF-8 encoding for stdout/stderr to support emojis on Windows terminals
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")

    args = parse_args()
    
    # Check if scan modules is requested
    if args.scan_modules:
        api_key = os.environ.get("GEMINI_API_KEY")
        if not api_key and not args.demo:
            print("⚠️  GEMINI_API_KEY environment variable not found.")
            print("🔄 Falling back to OFFLINE DEMO mode for Test Case Generation.")
            print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
            args.demo = True
        scan_and_generate_modules(args, api_key)
        return

    # Check if a specific module name is requested (automatic paths)
    if args.module:
        modules_dir = os.path.abspath(os.path.join(os.path.dirname(SCRIPT_DIR), "modules"))
        mod_path = os.path.join(modules_dir, args.module)
        vars_file = os.path.join(mod_path, "variables.tf")
        
        if not os.path.exists(vars_file):
            sys.stderr.write(f"Error: Module '{args.module}' or its 'variables.tf' does not exist under '{mod_path}'.\n")
            sys.exit(1)
            
        tests_dir = os.path.join(mod_path, "tests")
        output_file = os.path.join(tests_dir, "unit.tftest.hcl")
        
        # Check for existing test file to prevent overwriting manual work
        if os.path.exists(output_file) and not args.force:
            sys.stderr.write(f"Error: Output file '{output_file}' already exists. Use --force to overwrite.\n")
            sys.exit(1)
            
        print(f"📦 Target module matched: '{args.module}'")
        
        api_key = os.environ.get("GEMINI_API_KEY")
        if not api_key and not args.demo:
            print("⚠️  GEMINI_API_KEY environment variable not found.")
            print("🔄 Falling back to OFFLINE DEMO mode for Test Case Generation.")
            print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
            args.demo = True
            
        try:
            os.makedirs(tests_dir, exist_ok=True)
        except Exception as e:
            sys.stderr.write(f"Error creating tests directory: {str(e)}\n")
            sys.exit(1)
            
        if args.demo:
            if args.module == "compute":
                try:
                    with open(DEFAULT_EXPECTED_TEST, "r", encoding="utf-8") as f:
                        content = f.read()
                except Exception as e:
                    sys.stderr.write(f"Error reading expected test: {str(e)}\n")
                    sys.exit(1)
            else:
                content = f"""# Mock compliance tests for module: {args.module}
# Generated in offline demo mode

mock_provider "azurerm" {{}}

variables {{
  # Default test variables for {args.module}
}}

run "validate_compliance" {{
  command = plan

  assert {{
    condition     = true
    error_message = "Compliance policy validation placeholder for {args.module}"
  }}
}}
"""
            try:
                with open(output_file, "w", encoding="utf-8") as out_f:
                    out_f.write(content)
                print(f"✅ Successfully wrote cached/mock test to {output_file}")
            except Exception as e:
                sys.stderr.write(f"Error writing to {output_file}: {str(e)}\n")
                sys.exit(1)
        else:
            print(f"🧠 Querying Gemini for unit test case generation for '{args.module}'...")
            try:
                hcl_variables = read_hcl_file(vars_file)
            except Exception as e:
                sys.stderr.write(f"Error reading variables file: {str(e)}\n")
                sys.exit(1)
                
            prompt = f"""You are an expert Terraform quality control and compliance test engineer.
You are tasked with writing native unit test blocks (.tftest.hcl) validating that module inputs conform to security and sizing guidelines.

### Variable Definitions (HCL) for Module '{args.module}':
```hcl
{hcl_variables}
```

Please generate the `.tftest.hcl` file. Follow these strict guidelines:
1. Include a mock_provider block: `mock_provider "azurerm" {{}}`.
2. Define a default variables block declaring standard test parameters.
3. Write multiple `run` test blocks (e.g. command = plan) that evaluate the variables.
4. For each run block, define at least one `assert` block validating input compliance.
5. Include helpful `error_message` strings.
6. Return ONLY the raw HCL code. Do not wrap in markdown code blocks. Start output directly with HCL comments.
"""
            try:
                generated_test = call_gemini_api(api_key, prompt)
            except Exception as e:
                sys.stderr.write(f"Error calling Gemini API: {str(e)}\n")
                sys.exit(1)
                
            clean_test = generated_test.strip()
            if clean_test.startswith("```hcl"):
                clean_test = clean_test[6:]
            elif clean_test.startswith("```terraform"):
                clean_test = clean_test[12:]
            if clean_test.startswith("```"):
                clean_test = clean_test[3:]
            if clean_test.endswith("```"):
                clean_test = clean_test[:-3]
            clean_test = clean_test.strip()
            
            try:
                with open(output_file, "w", encoding="utf-8") as out_f:
                    out_f.write(clean_test)
                print(f"✅ Successfully wrote live Terraform unit test block to {output_file}")
            except Exception as e:
                sys.stderr.write(f"Error writing to {output_file}: {str(e)}\n")
                sys.exit(1)
        return

    # Check for existing single output file to prevent overwriting manual work
    if os.path.exists(args.output) and not args.force:
        sys.stderr.write(f"Error: Output file '{args.output}' already exists. Use --force to overwrite.\n")
        sys.exit(1)

    # 1. Check for Demo mode
    if args.demo:
        print("🤖 Running Test Generator in OFFLINE DEMO mode...")
        if not os.path.exists(DEFAULT_EXPECTED_TEST):
            sys.stderr.write(f"Error: Pre-cached test file '{DEFAULT_EXPECTED_TEST}' not found.\n")
            sys.exit(1)
            
        with open(DEFAULT_EXPECTED_TEST, "r", encoding="utf-8") as f:
            content = f.read()
            
        with open(args.output, "w", encoding="utf-8") as out_f:
            out_f.write(content)
            
        print(f"✅ Successfully wrote cached OPA test block to {args.output}")
        sys.exit(0)

    # 2. Live LLM Mode
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("⚠️  GEMINI_API_KEY environment variable not found.")
        print("🔄 Falling back to OFFLINE DEMO mode for Test Case Generation.")
        print("💡 Hint: Set GEMINI_API_KEY to test the live API call.")
        args.demo = True
        main()
        return

    print("📝 Reading Terraform variables file...")
    hcl_variables = read_hcl_file(args.variables_file)
    
    print("🧠 Querying Gemini for unit test case generation (.tftest.hcl)...")
    prompt = f"""You are an expert Terraform quality control and compliance test engineer.
You are tasked with writing native unit test blocks (.tftest.hcl) validating that module inputs conform to security and sizing guidelines.

### Variable Definitions (HCL):
```hcl
{hcl_variables}
```

Please generate the `.tftest.hcl` file. Follow these strict guidelines:
1. Include a mock_provider block: `mock_provider "azurerm" {{}}`.
2. Define a default variables block declaring standard test parameters.
3. Write multiple `run` test blocks (e.g. command = plan) that evaluate the variables.
4. For each run block, define at least one `assert` block. The condition must validate compliance (for example: enforcing that VM size inputs are burstable Standard_B-series tiers or password authentication is disabled).
5. Include helpful `error_message` strings.
6. Return ONLY the raw HCL code. Do not wrap in markdown code blocks. Start output directly with HCL comments.
"""

    generated_test = call_gemini_api(api_key, prompt)
    
    # Clean output wrappers
    clean_test = generated_test.strip()
    if clean_test.startswith("```hcl"):
        clean_test = clean_test[6:]
    elif clean_test.startswith("```terraform"):
        clean_test = clean_test[12:]
    if clean_test.startswith("```"):
        clean_test = clean_test[3:]
    if clean_test.endswith("```"):
        clean_test = clean_test[:-3]
    clean_test = clean_test.strip()
    
    with open(args.output, "w", encoding="utf-8") as out_f:
        out_f.write(clean_test)
    print(f"✅ Successfully wrote live Terraform unit test block to {args.output}")

if __name__ == "__main__":
    main()
