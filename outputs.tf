output "this" {
  description = "The key vault."
  value       = azurerm_key_vault.this
}
output "id" {
  description = "The key vault ID."
  value       = azurerm_key_vault.this.id
}
output "name" {
  description = "The key vault name."
  value       = azurerm_key_vault.this.name
}
output "private_endpoint" {
  description = "The private endpoint instance."
  value       = var.private_endpoint.enable ? azurerm_private_endpoint.this.0 : null
}
