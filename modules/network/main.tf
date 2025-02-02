resource "azurerm_virtual_network" "public" {
  name                = var.vnet_name
  address_space       = ["10.10.0.0/24"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "targets_subnet" {
  name                 = var.targets_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.10.0.0/25"]
}

resource "azurerm_subnet" "prom_server_subnet" {
  name                 = var.server_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.10.0.128/25"]
}
