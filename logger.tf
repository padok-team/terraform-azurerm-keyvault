module "logger" {
  source = "git@github.com:padok-team/terraform-azurerm-logger.git?ref=v0.50"

  count = var.logging.enabled ? 1 : 0

  create_new_workspace       = false
  name                       = "logger"
  log_analytics_workspace_id = var.logging.log_analytics_workspace_id

  resource_group = var.resource_group

  resources_to_logs = [
    azurerm_key_vault.this.id
  ]

  resources_to_metrics = [
    azurerm_key_vault.this.id
  ]
}
