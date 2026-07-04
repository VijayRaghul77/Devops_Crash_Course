# Day 01: Azure Storage Account Deployment with Terraform

This project demonstrates how to set up Terraform with the `azurerm` provider to deploy a basic Resource Group and a Storage Account in Microsoft Azure.

---

## 📋 Task Overview
1. **Target Infrastructure**:
   - **Resource Group**: `storage_rg` located in `East US`.
   - **Storage Account**: A globally unique standard storage account (`vrdevopsstorage101`) configured with Local Redundant Storage (LRS) replication.
2. **Provider**: `hashicorp/azurerm` (v4.8.0).

---

## ⚙️ Prerequisites
Before running the Terraform configurations, ensure you have the following installed and configured:
- [Terraform](https://www.terraform.io/downloads.html) (>= 1.9.0)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

---

## 🔐 Authentication Setup

You can authenticate the `azurerm` provider using either the Azure CLI (interactive/development) or a Service Principal (recommended for CI/CD pipelines).

### Option A: Interactive Login (Azure CLI)
If you are running commands locally on your machine, you can log in interactively:
```bash
# Log in to Azure via browser
az login

# List subscriptions to identify your Subscription ID
az account list --output table

# Set the active subscription context
az account set --subscription "<subscription-id>"
```

### Option B: Non-Interactive Login (Service Principal)
For automated pipelines or service-account authentication, create a Service Principal:
```bash
az ad sp create-for-rbac -n azure-terraform --role="Contributor" --scopes="/subscriptions/<subscription-id>"
```
This command outputs credentials that map to the environment variables below.

---

## 🌐 Environment Variables Configuration
In `azurerm` provider **v4.x**, the `subscription_id` is a required configuration. Set these variables according to your Operating System's shell before executing Terraform:

### 💻 Windows PowerShell
```powershell
$env:ARM_CLIENT_ID="<client-id>"
$env:ARM_CLIENT_SECRET="<client-secret>"
$env:ARM_TENANT_ID="<tenant-id>"
$env:ARM_SUBSCRIPTION_ID="<subscription-id>"
```

### 🪟 Windows CMD
```cmd
set ARM_CLIENT_ID=<client-id>
set ARM_CLIENT_SECRET=<client-secret>
set ARM_TENANT_ID=<tenant-id>
set ARM_SUBSCRIPTION_ID=<subscription-id>
```

### 🐧 Linux / macOS / Git Bash
```bash
export ARM_CLIENT_ID="<client-id>"
export ARM_CLIENT_SECRET="<client-secret>"
export ARM_TENANT_ID="<tenant-id>"
export ARM_SUBSCRIPTION_ID="<subscription-id>"
```

---

## 🚀 Execution Steps

1. **Initialize Terraform**:
   Downloads the necessary Azure provider plugins.
   ```bash
   terraform init
   ```

2. **Generate and Review Execution Plan**:
   Shows what resources will be created.
   ```bash
   terraform plan
   ```

3. **Apply the Plan**:
   Deploys resources to Azure.
   ```bash
   terraform apply --auto-approve
   ```

---

## 🛠️ Troubleshooting & Lessons Learned

### 1. Error: `subscription_id` is a required provider property
* **Cause**: Beginning with AzureRM v4.0, provider properties (like `subscription_id`) are strictly required. They can no longer be silently auto-detected from the CLI if left empty.
* **Solution**: Ensure `subscription_id` is set as an environment variable or declared explicitly in the `provider` block:
  ```hcl
  provider "azurerm" {
    features {}
    subscription_id = "aa2cd9ce-8c46-463c-91db-74bf555e2097"
    tenant_id       = "955ca1aa-6ef6-4a8f-b03c-8a34e73b8c73"
  }
  ```

### 2. Error: `StorageAccountAlreadyTaken` (409 Conflict)
* **Cause**: Azure Storage Account names are globally unique across all of Azure. Common names like `automation101` are usually already taken.
* **Solution**: Keep names between 3–24 characters using only lowercase letters and numbers. Incorporate a unique identifier or initials (e.g. `vrdevopsstorage101`).
