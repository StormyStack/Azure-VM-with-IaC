# Bastion requires a Standard SKU public IP with static allocation.
resource "azurerm_public_ip" "bastion" {
  name                = "${var.name_prefix}-bastion-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge(var.tags, { Name = "${var.name_prefix}-bastion-pip" })
}

# Basic SKU is sufficient for SSH/RDP access. Standard SKU adds native client support, tunneling, and IP-based connections.
resource "azurerm_bastion_host" "main" {
  name                = "${var.name_prefix}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  tags                = merge(var.tags, { Name = "${var.name_prefix}-bastion" })

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
