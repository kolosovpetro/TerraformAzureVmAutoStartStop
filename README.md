# Azure VM Start-Stop on Schedule using Terraform, Azure Automation, and PowerShell Runbooks

Automates Azure VM start/stop using Azure Automation and PowerShell runbooks. Deploys Windows/Linux VMs, an Automation
Account, and a runbook to update PowerShell modules. Dynamically schedules updates (+0.5hr UTC+1) and VM start/stop
tasks (+1hr UTC+1) based on VM tags to optimize costs.

## Terraform Init

- Create and configure Azure Storage Account for Terraform state
- Create `azure.sas.conf` file with the following content:
    ```bash
    storage_account_name = "storage_account_name"
    container_name       = "container_name"
    key                  = "terraform.tfstate"
    sas_token            = "sas_token"
    ```
- `terraform init -backend-config="azure.sas.conf" -reconfigure -upgrade`
