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

module "keyvault" {
  source = "../.."
  name  = "openkeyvault" # Needs to be globaly unique
  resource_group_name = "test-keyvault"
  sku_name = "standard"
  network_acls = {
    ip_rules = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }
  tags = {
    terraform = "true"
    padok     = "library"
  }
}
