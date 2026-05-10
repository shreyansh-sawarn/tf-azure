# Makefile for tf-azure

# Standardize common infrastructure tasks for developers

.PHONY: all fmt validate plan security-scan help

# Default target
all: fmt validate security-scan

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
	@echo "  plan-dev       Run terragrunt plan for Dev"
	@echo "  apply-dev      Run terragrunt apply for Dev"
	@echo "  all            Run fmt, validate, and security-scan"
