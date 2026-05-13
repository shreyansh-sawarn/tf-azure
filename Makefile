# Makefile for tf-azure

# Standardize common infrastructure tasks for developers

.PHONY: all fmt validate plan security-scan test policy-check help

# Default target
all: fmt validate security-scan test policy-check

## Code Quality
fmt:
	@echo "🎨 Formatting Terraform code..."
	terraform fmt -recursive

validate:
	@echo "🔍 Validating Terragrunt configurations..."
	terragrunt run-all validate

security-scan:
	@echo "🛡️  Running security scan with tfsec..."
	tfsec .

test:
	@echo "🧪 Running Terraform native tests..."
	@find modules -name "*.tftest.hcl" -exec dirname {} \; | sort -u | while read test_dir; do \
		module_dir=$$(dirname "$$test_dir"); \
		echo "Testing $$module_dir..."; \
		terraform -chdir="$$module_dir" init -backend=false > /dev/null 2>&1; \
		terraform -chdir="$$module_dir" test; \
	done

policy-check:
	@echo "⚖️  Running OPA policy checks with Conftest..."
	@echo "Example: conftest test tfplan.json --policy policy/"
	# conftest test tfplan.json --policy policy/

## Environment Operations (Dev)
plan-dev:
	@echo "📝 Generating execution plan for Dev environment..."
	cd environments/dev && terragrunt run-all plan

apply-dev:
	@echo "🚀 Applying infrastructure changes to Dev environment..."
	cd environments/dev && terragrunt run-all apply

## Help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  fmt            Format all Terraform files"
	@echo "  validate       Validate all Terragrunt components"
	@echo "  security-scan  Run security vulnerability scan"
	@echo "  test           Run Terraform native tests"
	@echo "  policy-check   Run OPA policy checks"
	@echo "  plan-dev       Run terragrunt plan for Dev"
	@echo "  apply-dev      Run terragrunt apply for Dev"
	@echo "  all            Run fmt, validate, security-scan, test, and policy-check"
