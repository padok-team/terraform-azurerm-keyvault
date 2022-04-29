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

data "azurerm_client_config" "self" {}
resource "random_pet" "random" {}

resource "azurerm_resource_group" "example" {
  name     = "test-keyvault"
  location = "francecentral"
}

module "keyvault" {
  source = "../.."

  name                = random_pet.random.id # Needs to be globaly unique
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "standard"

  network_acls = {
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }

  access_policy = {
    (data.azurerm_client_config.self.object_id) : {
      secret_permissions = ["Get", "List"]
    }
  }

  tags = {
    terraform = "true"
    padok     = "library"
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}
