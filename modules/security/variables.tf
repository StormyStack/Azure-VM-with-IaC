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

variable "app_subnet_id" {
  type        = string
  description = "ID of the application subnet to associate the NSG with"
}
