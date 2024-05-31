provider "azurerm" {
    features {
 
    }
}
 
data "azurerm_resource_group" "RG" {
    name = "TEST"
    }
 
resource "azurerm_virtual_network" "NET" {
  name                = "minenet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.RG.location
  resource_group_name = data.azurerm_resource_group.RG.name
  }
 
resource "azurerm_subnet" "SUBNET" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.NET.name
  address_prefixes     = ["10.0.0.0/20"]
}
 
resource "azurerm_public_ip" "PIP" {
  name                = "minepip"
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = data.azurerm_resource_group.RG.location
  allocation_method   = "Static"  # Wähle hier "Dynamic" oder "Static" basierend auf deinen Anforderungen
}
 
resource "azurerm_network_interface" "NIC" {
  name                = "minenic"
  location            = data.azurerm_resource_group.RG.location
  resource_group_name = data.azurerm_resource_group.RG.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SUBNET.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PIP.id
  }
}
 
resource "azurerm_linux_virtual_machine" "VM" {
  name                = "MineServer"
  resource_group_name = data.azurerm_resource_group.RG.name
  location            = data.azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = "admin"
  admin_password = "123456"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]
 
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
 
  custom_data = filebase64("mine.sh")
}