# TerraformAzureVmAutoStartStop

Terraform module for automating Azure VM start and stop using Azure Automation and PowerShell playbooks. Enables
scheduled and on-demand VM management to optimize costs and resource usage.

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

# Module documentation
