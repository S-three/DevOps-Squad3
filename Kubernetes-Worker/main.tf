provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "existing_rg" {
  name     = "project-resource-group"
  location = "Canada Central"
}

resource "azurerm_virtual_network" "existing_vnet" {
  name                = "project-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.existing_rg.location
  resource_group_name = azurerm_resource_group.existing_rg.name
}

resource "azurerm_subnet" "example" {
  name                 = "k8s-worker-subnet"
  resource_group_name  = azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.existing_vnet.name
  address_prefixes     = ["10.0.6.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "k8s-worker-public-ip"
  location            = azurerm_resource_group.existing_rg.location
  resource_group_name = azurerm_resource_group.existing_rg.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "example" {
   name                      = "k8s-worker-nic"
     location                  = azurerm_resource_group.existing_rg.location
  resource_group_name       = azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "k8s-worker-vm"
  location              = azurerm_resource_group.existing_rg.location
  resource_group_name   = azurerm_resource_group.existing_rg.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS2_v2"



  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "k8s-worker-vm"
        admin_username = "adminuser"
    admin_password = "Password1234!"
  }


 storage_os_disk {
    name              = "k8s-worker-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Dev"
  }
}
