resource "random_pet" "random" {}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "test-keyvault"
  location = "francecentral"
}

module "keyvault" {
  source = "../.."
  name   = random_pet.random.id # Vault names are globaly unique

  resource_group = azurerm_resource_group.this
  tenant_id      = data.azurerm_client_config.this.tenant_id

  enable_network_acl = false
  sku_name           = "standard"
}
