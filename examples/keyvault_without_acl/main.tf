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

  resource_group = azurerm_resource_group.this
  tenant_id      = data.azurerm_client_config.this.tenant_id

  enable_network_acl = false
  sku_name           = "standard"

  logging = {
    enabled                    = true
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }
}
