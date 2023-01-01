data "azurerm_client_config" "this" {}

resource "random_pet" "this" {}


resource "azurerm_resource_group" "this" {
  name     = "keyvault"
  location = "francecentral"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = random_pet.this.id
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  enforce_private_link_endpoint_network_policies = true

  address_prefixes = ["10.0.0.0/28"]
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}


module "keyvault" {
  source = "../.."

  resource_group = azurerm_resource_group.this
  tenant_id      = data.azurerm_client_config.this.tenant_id

  name     = random_pet.this.id
  sku_name = "standard"

  private_endpoint = {
    enable              = true
    subnet_id           = azurerm_subnet.this.id
    private_dns_zone_id = azurerm_private_dns_zone.this.id
  }
}
