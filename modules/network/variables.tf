variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "targets_subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "server_subnet_name" {
  type        = string
  description = "Name of the subnet"
}
