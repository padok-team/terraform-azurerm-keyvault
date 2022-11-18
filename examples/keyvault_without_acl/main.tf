# Short description of the use case in comments

terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.82.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.4"
    }
  }
}
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  features {}
}

resource "random_pet" "random" {}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "test-keyvault"
  location = "francecentral"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "test-keyvault-law"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
}

module "keyvault" {
  source = "../.."
  name   = random_pet.random.id # Vault names are globaly unique

  resource_group             = azurerm_resource_group.this
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  enable_network_acl         = false
  sku_name                   = "standard"
}
