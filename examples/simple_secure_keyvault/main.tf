# Short description of the use case in comments

terraform {
  required_version = ">= 1.0.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.82.0"
    }
  }
}
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  features {}
}

resource "random_pet" "random" {}

resource "azurerm_resource_group" "example" {
  name     = "test-keyvault"
  location = "francecentral"
}

module "keyvault" {
  source              = "../.."
  name                = random_pet.random.id # Vault names are globaly unique
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "standard"

  depends_on = [
    azurerm_resource_group.example
  ]
}
