# No public IP is assigned. The VM is accessible only through Azure Bastion.
resource "azurerm_network_interface" "main" {
  name                = "${var.name_prefix}-${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, { Name = "${var.name_prefix}-${var.vm_name}-nic" })

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# No managed identity — this VM does not access Azure resources at runtime. The SSH public key is retrieved by Terraform at deploy-time, not by the VM.
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  # Enforce SSH key authentication. Password login is disabled for security.
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.main.id]
  tags                            = merge(var.tags, { Name = var.vm_name })

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  # Ubuntu 24.04 LTS — long-term support with security updates until 2029.
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
