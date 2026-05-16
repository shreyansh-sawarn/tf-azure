# Troubleshooting Guide

Common issues and solutions for maintaining and developing this repository.

## 1. State Lock Errors
**Issue:** `Error: Error acquiring the state lock`
**Cause:** A previous deployment failed or was interrupted, leaving a lock lease on the Azure Blob.
**Solution:**
1. Verify no other CI/CD jobs are running.
2. Manually break the lease in the Azure Portal (State Storage Account > Containers > tfstate > Select file > "Break Lease").
3. Or use the CLI: `terragrunt force-unlock <LOCK_ID>` (only if you have the lock ID from the error message).

## 2. Policy Violations (OPA/Conftest)
**Issue:** `FAIL - policy/infra_policies.rego: SQL Server has public network access enabled`
**Cause:** Your configuration violates one of the 8 governance rules.
**Solution:** Check the specific resource in the error message and adjust the `public_network_access_enabled` or `min_tls_version` settings to comply with the project standards.

## 3. Mock Test Failures
**Issue:** `Error: decoding "admin_ssh_key.0.public_key" for public key data`
**Cause:** The SSH public key string provided in the unit test is truncated or improperly formatted.
**Solution:** Ensure the `admin_ssh_key_public` variable in the module's `unit.tftest.hcl` is a full, valid RSA public key string (`ssh-rsa AAAAB3...`).

## 4. Infracost Failures
**Issue:** `Error: No valid Infracost API key found`
**Cause:** The `INFRACOST_API_KEY` environment variable is not set locally or in GitHub Secrets.
**Solution:** Run `infracost auth login` to get a key, or verify the secret `INFRACOST_API_KEY` exists in the GitHub repository.

## 5. Formatting Failures
**Issue:** `Error: Terraform exited with code 3`
**Cause:** `terraform fmt -check` found misaligned code.
**Solution:** Run `terraform fmt -recursive` from the project root to automatically align equals signs and fix indentation.
