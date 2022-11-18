
# Resource : azurerm_key_vault
resource "azurerm_key_vault" "this" {
  name                            = var.name
  location                        = var.resource_group.location
  resource_group_name             = var.resource_group.name
  sku_name                        = var.sku_name
  tenant_id                       = var.tenant_id
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  # Allow all azure services but Deny everyting else
  dynamic "network_acls" {
    for_each = var.enable_network_acl ? [0] : []
    content {
      bypass                     = "AzureServices"
      default_action             = "Deny"
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }

  purge_protection_enabled   = true
  soft_delete_retention_days = var.soft_delete_retention_days

  dynamic "access_policy" {
    for_each = var.access_policy
    content {
      tenant_id               = var.tenant_id
      object_id               = access_policy.key
      application_id          = access_policy.value.application_id
      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }

  tags = var.tags
}

module "logger" {
  source                     = "git@github.com:padok-team/terraform-azurerm-logger.git?ref=v0.2.0"
  count                      = var.logs_enabled ? 1 : 0
  log_analytics_workspace_id = var.log_analytics_workspace_id
  create_new_workspace       = false
  resource_group             = var.resource_group
  name                       = "logger"
  resources_to_logs = [
    azurerm_key_vault.this.id
  ]
  resources_to_metrics = [
    azurerm_key_vault.this.id
  ]
}
