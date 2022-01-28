# Data
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "this" {}

# Resource : azurerm_key_vault
resource "azurerm_key_vault" "this" {
  name                            = var.name
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  sku_name                        = var.sku_name
  tenant_id                       = data.azurerm_client_config.this.tenant_id
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  # Allow all azure services but Deny everyting else
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }

  purge_protection_enabled   = true
  soft_delete_retention_days = var.soft_delete_retention_days
  tags                       = var.tags
}
data "azurerm_monitor_diagnostic_categories" "this" {
  count       = var.logs_enabled ? 1 : 0
  resource_id = azurerm_key_vault.this.id
}
resource "azurerm_monitor_diagnostic_setting" "this" {
  count              = var.logs_enabled ? 1 : 0
  name               = "Diagnostic-${var.name}"
  target_resource_id = azurerm_key_vault.this.id

  log_analytics_workspace_id     = var.log_analytics_workspace_id
  storage_account_id             = var.storage_account_id
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  log_analytics_destination_type = null

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.this[count.index].logs
    content {
      category = log.value
      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }
  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.this[count.index].metrics
    content {
      category = metric.value
      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }
}
