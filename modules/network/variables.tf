variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the VNet"
}

variable "app_subnet_prefix" {
  type        = string
  description = "CIDR prefix for the application subnet"
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "CIDR prefix for the AzureBastionSubnet"
}
