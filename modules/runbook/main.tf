resource "azurerm_automation_account" "automation-account" {
  name                = var.automation_account_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "rbac_system_identity" {
  scope                = var.subscription_id
  principal_id         = azurerm_automation_account.automation-account.identity[0].principal_id
  role_definition_name = "Contributor"
}

resource "azurerm_automation_runbook" "update_powershell_modules" {
  name                    = "AzureAutomation-Account-Modules-Update"
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation-account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This runbook updates the powershell Az modules"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/microsoft/AzureAutomation-Account-Modules-Update/master/Update-AutomationAzureModulesForAccount.ps1"
  }
}

resource "azurerm_automation_schedule" "update_powershell_modules_schedule" {
  name                    = "Update PS Az Modules schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation-account.name
  frequency               = "Month"
  interval                = 1
  timezone                = "Europe/Paris"
  start_time              = var.schedule_updatepsmodules_start_time
  description             = "Monthly schedule to update PS Az modules"
  month_days              = ["1"]
}

resource "azurerm_automation_job_schedule" "update_powershell_modules_job" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation-account.name
  schedule_name           = azurerm_automation_schedule.update_powershell_modules_schedule.name
  runbook_name            = azurerm_automation_runbook.update_powershell_modules.name

  parameters = {
    azuremoduleclass        = "Az"
    resourcegroupname       = var.resource_group_name
    automation_account_name = azurerm_automation_account.automation-account.name
  }
}

resource "azurerm_automation_runbook" "start_and_stop_vm_runbook" {
  name                    = "Start-and-Stop-VMs"
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation-account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This runbook starts and stops VMs based on their tags"
  runbook_type            = "PowerShell"
  content                 = var.local_file_start_and_stop_vm_script_content
}
