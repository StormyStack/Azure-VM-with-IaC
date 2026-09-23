output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "app_subnet_id" {
  description = "The ID of the application subnet"
  value       = azurerm_subnet.app.id
}

output "bastion_subnet_id" {
  description = "The ID of the AzureBastionSubnet"
  value       = azurerm_subnet.bastion.id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = azurerm_public_ip.nat.ip_address
}
