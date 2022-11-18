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

data "azurerm_client_config" "this" {}

resource "random_pet" "random" {}

resource "azurerm_resource_group" "example" {
  name     = "test-keyvault"
  location = "francecentral"
}

module "keyvault" {
  source = "../.."

  name = random_pet.random.id # Needs to be globaly unique

  resource_group             = azurerm_resource_group.example
  tenant_id                  = data.azurerm_client_config.this.tenant_id
  log_analytics_workspace_id = data.azurerm_client_config.this.workspace_id
  sku_name                   = "standard"

  network_acls = {
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }

  access_policy = {
    (data.azurerm_client_config.this.object_id) : {
      secret_permissions = ["Get", "List"]
    }
  }

  tags = {
    terraform = "true"
    padok     = "library"
  }
}
