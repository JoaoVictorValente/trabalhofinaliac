# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "student-rg"
  location = var.resource_group_location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "student-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "student-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "myPubIP" {
  count               = var.number_resources
  name                = "student-pip-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "student-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interface (NIC)
resource "azurerm_network_interface" "nic" {
  count               = var.number_resources
  name                = "student-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-${count.index + 1}-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myPubIP[count.index].id
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nicNSG" {
  count                     = var.number_resources
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# SSH Key Generation
resource "random_password" "vm_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Generate SSH Key Pair
resource "tls_private_key" "ssh_key" {
  count = var.number_resources

  algorithm = "RSA"
  rsa_bits  = 4096
}

# Virtual Machine (VM)
resource "azurerm_linux_virtual_machine" "myVM" {
  count                 = var.number_resources
  name                  = "student-vm-${count.index + 1}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "student-osdisk-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "student-vm-${count.index + 1}"
  admin_username = var.username
  admin_password = var.admin_password

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.ssh_key[count.index].public_key_openssh
  }

  depends_on = [azurerm_network_interface_security_group_association.nicNSG]
}

# Generate Ansible Inventory
resource "local_file" "hosts_cfg" {
  content = templatefile("inventory.tpl", {
    vms      = azurerm_linux_virtual_machine.myVM
    username = var.username
  })
  filename = "./ansible/inventory.yml"
}

# Variables
variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Local onde o grupo de recursos será criado"
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefixo que será anexado ao nome randômico de grupo de recursos"
}

variable "username" {
  type        = string
  description = "O usuário que será usado para nos conectarmos nas VMs"
  default     = "azureadmin"
}

variable "number_resources" {
  type        = number
  default     = 1
  description = "Número de VMs que serão criadas"
}

variable "admin_password" {
  description = "Password for the admin user on the virtual machine"
  type        = string
  default     = ""
}
