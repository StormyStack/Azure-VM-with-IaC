variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "environment" {
  type        = string
  description = "Environment name"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project" {
  type        = string
  default     = "demo"
  description = "Project name used in resource naming"
}

variable "owner" {
  type        = string
  description = "Owner tag for resources"
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the virtual network"
}

variable "app_subnet_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR prefix for the application subnet"
}

variable "bastion_subnet_prefix" {
  type        = string
  default     = "10.0.2.0/26"
  description = "CIDR prefix for the AzureBastionSubnet. Must be /26 or larger"
}

variable "vm_name" {
  type        = string
  description = "Name of the Linux virtual machine"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "Size of the virtual machine"
}

variable "admin_username" {
  type        = string
  default     = "azureadmin"
  description = "Admin username for the VM"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the local SSH public key file"
}
