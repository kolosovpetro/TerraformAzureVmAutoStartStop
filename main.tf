data "azurerm_subscription" "current" {}

data "local_file" "start_stop_powershell_script_path" {
  filename = "${path.root}/scripts/StartStop-AzureVM.ps1"
}

module "azure_region" {
  source       = "claranet/regions/azurerm"
  version      = ">=7.0.0"
  azure_region = var.location
}

resource "azurerm_resource_group" "public" {
  location = module.azure_region.location_cli
  name     = "${var.resource_group_name}-${var.prefix}"
  tags     = var.tags
}

resource "azurerm_virtual_network" "public" {
  name                = "vnet-az-automation"
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.public.location
  resource_group_name = azurerm_resource_group.public.name
}

resource "azurerm_subnet" "public" {
  name                 = "snet-az-automation"
  resource_group_name  = azurerm_resource_group.public.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.10.0.0/25"]
}

module "linux_server" {
  source                            = "./modules/azure-linux-vm-key-auth"
  ip_configuration_name             = "ipc-linux-${var.prefix}"
  network_interface_name            = "nic-linux-${var.prefix}"
  os_profile_admin_public_key_path  = "${path.root}/id_rsa.pub"
  os_profile_admin_username         = "razumovsky_r"
  os_profile_computer_name          = "vm-linux-${var.prefix}"
  resource_group_location           = "northeurope"
  resource_group_name               = azurerm_resource_group.public.name
  storage_image_reference_offer     = "0001-com-ubuntu-server-jammy"
  storage_image_reference_publisher = "Canonical"
  storage_image_reference_sku       = "22_04-lts-gen2"
  storage_image_reference_version   = "latest"
  storage_os_disk_caching           = "ReadWrite"
  storage_os_disk_create_option     = "FromImage"
  storage_os_disk_managed_disk_type = "StandardSSD_LRS"
  storage_os_disk_name              = "osdisk-linux-${var.prefix}"
  vm_name                           = "vm-linux-${var.prefix}"
  vm_size                           = "Standard_B4ms"
  public_ip_name                    = "pip-linux-${var.prefix}"
  subnet_id                         = azurerm_subnet.public.id
  network_security_group_id         = azurerm_network_security_group.public.id
  tags                              = local.vm_schedule_tags
}

module "windows_server" {
  source                      = "./modules/azure-windows-vm"
  ip_configuration_name       = "ipc-windows-${var.prefix}"
  network_interface_name      = "nic-windows-${var.prefix}"
  network_security_group_id   = azurerm_network_security_group.public.id
  os_profile_admin_password   = file("${path.root}/password.txt")
  os_profile_admin_username   = "razumovsky_r"
  os_profile_computer_name    = "vm-win-target"
  public_ip_name              = "pip-windows-${var.prefix}"
  resource_group_location     = "northeurope"
  resource_group_name         = azurerm_resource_group.public.name
  storage_image_reference_sku = "2022-Datacenter"
  storage_os_disk_name        = "osdisk-windows-${var.prefix}"
  subnet_id                   = azurerm_subnet.public.id
  vm_name                     = "vm-windows-${var.prefix}"
  vm_size                     = "Standard_B4ms"
  tags                        = local.vm_schedule_tags
}

# Automation account and runbook module

module "runbook" {
  source                                      = "./modules/runbook"
  automation_account_name                     = "aa-${var.prefix}"
  resource_group_location                     = azurerm_resource_group.public.location
  resource_group_name                         = azurerm_resource_group.public.name
  subscription_id                             = data.azurerm_subscription.current.id
  schedule_updatepsmodules_start_time         = local.schedule_update_ps_modules_start_time
  local_file_start_and_stop_vm_script_content = data.local_file.start_stop_powershell_script_path.content
}

# Create the schedules

resource "azurerm_automation_schedule" "start_stop_schedule" {
  name                    = local.schedule_start_stop_vm_name
  resource_group_name     = azurerm_resource_group.public.name
  automation_account_name = module.runbook.automation_account_name
  frequency               = "Hour"
  interval                = 1
  timezone                = "Europe/Dublin"
  start_time              = local.schedule_start_stop_vm_start_time
  description             = "Hourly schedule to start and stop VMs"

  depends_on = [
    module.runbook
  ]
}

# Connect the schedules to the runbook
resource "azurerm_automation_job_schedule" "start_stop_job_schedule" {
  resource_group_name     = azurerm_resource_group.public.name
  automation_account_name = module.runbook.automation_account_name
  schedule_name           = local.schedule_start_stop_vm_name
  runbook_name            = module.runbook.start_and_stop_vm_runbook_name

  parameters = {
    subscriptionid    = data.azurerm_subscription.current.id
    resourcegroupname = azurerm_resource_group.public.name
    tagname           = "StopStartSchedule"
    timezone          = "GMT Standard Time"
  }

  depends_on = [
    azurerm_automation_schedule.start_stop_schedule
  ]
}