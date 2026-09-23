# No secrets are exposed in outputs.

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Virtual network name"
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = module.network.vnet_id
}

output "app_subnet_id" {
  description = "Application subnet ID"
  value       = module.network.app_subnet_id
}

output "vm_name" {
  description = "VM name"
  value       = module.vm.vm_name
}

output "vm_private_ip" {
  description = "VM private IP"
  value       = module.vm.vm_private_ip
}

output "bastion_name" {
  description = "Bastion host name"
  value       = module.bastion.bastion_name
}

output "bastion_public_ip" {
  description = "Bastion public IP. Use this to connect via Bastion."
  value       = module.bastion.bastion_public_ip
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway. VM outbound traffic appears from this IP"
  value       = module.network.nat_gateway_public_ip
}
