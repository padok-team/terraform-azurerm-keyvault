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

module "keyvault" {
  source = "../.."
  name  = "keyvaulttest123soleil" # Vault names are globaly unique
  resource_group_name = "test-keyvault"
  sku_name = "standard"
}
