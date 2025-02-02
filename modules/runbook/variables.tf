variable "resource_group_location" {
  description = "Resource group location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "automation_account_name" {
  description = "The name of the Azure Automation Account"
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID"
  type        = string
}

variable "schedule_updatepsmodules_start_time" {
  description = "The time to start the schedule"
  type        = string
}

variable "local_file_start_and_stop_vm_script_content" {
  description = "The content of the start and stop VM script"
  type        = string
}
