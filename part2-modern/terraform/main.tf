# 1. Resource Group
resource "azurerm_resource_group" "modern" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "modern-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.modern.location
  resource_group_name = azurerm_resource_group.modern.name
}

# 3. Subnet for Container Apps 
resource "azurerm_subnet" "container_subnet" {
  name                 = "aca-subnet"
  resource_group_name  = azurerm_resource_group.modern.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/23"]

  delegation {
    name = "aca-delegation"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# 4. Subnet for Jumpbox
resource "azurerm_subnet" "jumpbox_subnet" {
  name                 = "jumpbox-subnet"
  resource_group_name  = azurerm_resource_group.modern.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 5. Internal Container App Environment
resource "azurerm_container_app_environment" "env" {
  name                           = "modern-aca-env"
  location                       = azurerm_resource_group.modern.location
  resource_group_name            = azurerm_resource_group.modern.name
  infrastructure_subnet_id       = azurerm_subnet.container_subnet.id
  internal_load_balancer_enabled = true 
}

# 6. Container App
resource "azurerm_container_app" "app" {
  name                         = "modern-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.modern.name
  revision_mode                = "Single"

  template {
    container {
      name   = "nginx-modern"
      image  = var.docker_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true 
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# 7. Jumpbox Public IP 
resource "azurerm_public_ip" "jumpbox_ip" {
  name                = "jumpbox-ip"
  location            = azurerm_resource_group.modern.location
  resource_group_name = azurerm_resource_group.modern.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 8. Jumpbox Network Interface
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "jumpbox-nic"
  location            = azurerm_resource_group.modern.location
  resource_group_name = azurerm_resource_group.modern.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumpbox_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_ip.id
  }
}

# 9. Jumpbox VM
resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = "modern-jumpbox"
  resource_group_name = azurerm_resource_group.modern.name
  location            = azurerm_resource_group.modern.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.jumpbox_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# 10. Network Security Group for SSH
resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "jumpbox-nsg"
  location            = azurerm_resource_group.modern.location
  resource_group_name = azurerm_resource_group.modern.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "118.100.234.157/32" 
    destination_address_prefix = "*"
  }
}

# 11. Associate NSG with the Network Interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.jumpbox_nic.id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}