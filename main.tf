locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    environment = var.environment
    project     = var.project
    managed_by  = "terraform"
    owner       = var.owner
  }
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}


module "network" {
  source = "./modules/network"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  name_prefix           = local.name_prefix
  tags                  = local.common_tags
  vnet_address_space    = var.vnet_address_space
  app_subnet_prefix     = var.app_subnet_prefix
  bastion_subnet_prefix = var.bastion_subnet_prefix
}

module "security" {
  source = "./modules/security"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name_prefix         = local.name_prefix
  tags                = local.common_tags
  app_subnet_id       = module.network.app_subnet_id
}

module "bastion" {
  source = "./modules/bastion"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name_prefix         = local.name_prefix
  tags                = local.common_tags
  bastion_subnet_id   = module.network.bastion_subnet_id
}

module "vm" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name_prefix         = local.name_prefix
  tags                = local.common_tags
  subnet_id           = module.network.app_subnet_id
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key      = file(var.ssh_public_key_path)
}
