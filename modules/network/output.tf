output "target_subnet_id" {
  value = azurerm_subnet.targets_subnet.id
}

output "targets_subnet_name" {
  value = azurerm_subnet.targets_subnet.name
}

output "prom_server_subnet_name" {
  value = azurerm_subnet.prom_server_subnet.name
}

output "prom_server_subnet_id" {
  value = azurerm_subnet.prom_server_subnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.public.name
}
