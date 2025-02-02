output "automation_account_name" {
  value       = azurerm_automation_account.automation_account.name
  description = "The name of the Azure Automation Account"
}

output "start_and_stop_vm_runbook_name" {
  value       = azurerm_automation_runbook.start_and_stop_vm_runbook.name
  description = "The name of the Azure Automation Runbook"
}
