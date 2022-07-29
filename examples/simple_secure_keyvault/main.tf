# Short description of the use case in comments

terraform {
  required_version = ">= 0.13.0"
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

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "example" {
  name     = "test-keyvault"
  location = "francecentral"
}

module "keyvault" {
  source = "../.."
  name   = random_pet.random.id # Vault names are globaly unique

  resource_group = azurerm_resource_group.example
  tenant_id      = data.azurerm_client_config.this.tenant_id

  sku_name = "standard"
}
