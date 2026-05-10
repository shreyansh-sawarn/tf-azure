#!/bin/bash
# bootstrap-state.sh — Create the Azure Storage Account for Terraform remote state
# This script ensures the foundational storage for IaC state management exists.

set -euo pipefail

# Configuration - Adjust these as needed or pass as environment variables
RESOURCE_GROUP="${TF_STATE_RG:-tf-azure-terraform-state-rg}"
STORAGE_ACCOUNT="${TF_STATE_SA:-tfazuretfstate}"
CONTAINER="${TF_STATE_CONTAINER:-tfstate}"
LOCATION="${TF_STATE_LOCATION:-eastus}"

echo "🚀 Starting bootstrap of Terraform state backend..."

# Create Resource Group
echo "Creating resource group: $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Create Storage Account
echo "Creating storage account: $STORAGE_ACCOUNT..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob \
  --https-only true \
  --min-tls-version TLS1_2

# Create Blob Container
echo "Creating container: $CONTAINER..."
az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT"

echo "✅ Terraform state backend bootstrap complete."
echo "------------------------------------------------"
echo "Resource Group:  $RESOURCE_GROUP"
echo "Storage Account: $STORAGE_ACCOUNT"
echo "Container:       $CONTAINER"
echo "------------------------------------------------"
