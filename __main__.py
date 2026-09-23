import pulumi
from pulumi_azure_native import resources, network, compute

# Config & Credentials
config = pulumi.Config()
location = config.get("location") or "southeastasia"
admin_username = config.get("admin_username") or "azureuser"
admin_password = config.get_secret("admin_password") or "Server123456"

# 1. Resource Group & Networking
resource_group = resources.ResourceGroup("resourceGroup", resource_group_name="PULUMI_RG", location=location)

virtual_network = network.VirtualNetwork("virtualNetwork",
    resource_group_name=resource_group.name,
    virtual_network_name="PULUMI_VNET",
    location=location,
    address_space={"address_prefixes": ["10.0.0.0/16"]})

subnet = network.Subnet("subnet",
    resource_group_name=resource_group.name,
    virtual_network_name=virtual_network.name,
    subnet_name="PULUMI_SUBNET",
    address_prefix="10.0.1.0/24")

nsg = network.NetworkSecurityGroup("networkSecurityGroup",
    resource_group_name=resource_group.name,
    network_security_group_name="PULUMI_NSG",
    location=location,
    security_rules=[{
        "name": "Allow-RDP-Inbound",
        "priority": 1000,
        "direction": "Inbound",
        "access": "Allow",
        "protocol": "Tcp",
        "sourcePortRange": "*",
        "destinationPortRange": "3389",
        "sourceAddressPrefix": "*",
        "destinationAddressPrefix": "*",
    }])

public_ip = network.PublicIPAddress("publicIp",
    resource_group_name=resource_group.name,
    public_ip_address_name="PULUMI_PUBLIC_IP",
    location=location,
    public_ip_allocation_method="Static",
    sku={"name": "Standard"})

nic = network.NetworkInterface("networkInterface",
    resource_group_name=resource_group.name,
    network_interface_name="PULUMI_NIC",
    location=location,
    enable_accelerated_networking=True,
    ip_configurations=[{
        "name": "PULUMI_NIC_CONFIG",
        "subnet": {"id": subnet.id},
        "public_ip_address": {"id": public_ip.id},
    }],
    network_security_group={"id": nsg.id})

# 2. Virtual Machine (Windows Server 2025)
vm = compute.VirtualMachine("virtualMachine",
    resource_group_name=resource_group.name,
    vm_name="PULUMI_VM",
    location=location,
    hardware_profile={"vm_size": config.get("vm_size") or "Standard_F4as_v6"},
    os_profile={
        "computer_name": "PULUMI-VM",
        "admin_username": admin_username,
        "admin_password": admin_password,
    },
    storage_profile={
        "image_reference": {
            "publisher": "MicrosoftWindowsDesktop",
            "offer": "windows-11",
            "sku": "win11-25h2-avd",
            "version": "latest",
        },
        "os_disk": {
            "name": "PULUMI_OS_DISK",
            "create_option": "FromImage",
            "disk_size_gb": 128,
            "delete_option": "Delete",
            "managed_disk": {"storage_account_type": "Premium_LRS"},
        },
    },
    network_profile={
        "network_interfaces": [{
            "id": nic.id,
            "delete_option": "Delete",
        }]
    })

# Exports
pulumi.export("public_ip_address", public_ip.ip_address)
pulumi.export("admin_username", admin_username)
pulumi.export("admin_password", pulumi.Output.secret(admin_password))
