data "azurerm_client_config" "this" {}

resource "random_pet" "random" {}

resource "azurerm_resource_group" "this" {
  name     = "test-keyvault"
  location = "francecentral"
}

module "keyvault" {
  source = "../.."

  name = random_pet.random.id # Needs to be globaly unique

  resource_group = azurerm_resource_group.this
  tenant_id      = data.azurerm_client_config.this.tenant_id
  sku_name       = "standard"

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
