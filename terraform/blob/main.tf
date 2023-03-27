terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "storage-group" {
  name     = "sg-demo"
  location = "Switzerland North"
}

resource "azurerm_storage_account" "sa-demo" {
  name                     = "noserdemo2023tf"
  resource_group_name      = azurerm_resource_group.storage-group.name
  location                 = azurerm_resource_group.storage-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc-demo" {
  name                  = "sc-demo"
  storage_account_name  = azurerm_storage_account.sa-demo.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.sa-demo.name
  storage_container_name = azurerm_storage_container.sc-demo.name
  type                   = "Block"
  source                 = "todo-list.zip"
}