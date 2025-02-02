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
  address_space = ["10.10.0.0/24"]
  location            = azurerm_resource_group.public.location
  resource_group_name = azurerm_resource_group.public.name
}

resource "azurerm_subnet" "public" {
  name                 = "snet-az-automation"
  resource_group_name  = azurerm_resource_group.public.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes = ["10.10.0.0/25"]
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
}