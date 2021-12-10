# Data
variable "resource_group_name" {
  type        = string
  description = "The Name of this Resource Group."
}

# Resource : azurerm_key_vault
variable "name" {
  type        = string
  description = "Specifies the name of the Key Vault. Vault names are globaly unique. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."

  validation {
    condition     = can(regex("^(standard|premium)$", var.sku_name))
    error_message = "The variable sku_name must be either standard or premium."
  }
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = false
}

variable "network_acls" {
  type = object({
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  description = "Network acls to deploy on the key vault. ip_rules is a list of IP or CIDR blocks"
  default     = {
    ip_rules = []
    virtual_network_subnet_ids = []
  }
}

variable "soft_delete_retention_days" {
  type        = string
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  default     = "90"
  validation {
    condition     = var.soft_delete_retention_days >= 7
    error_message = "Soft delete should be enabled for at least 7 days."
  }
}

variable "tags" {
  type        = map(string)
  description = " A mapping of tags to assign to the resource."
  default     = {}
}

# logging

variable "logs_enabled" {
  description = "Should the log export with DiagnosticSetting be enabled ?"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace where to export logs."
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "The ID of the storage account where to export logs."
  type        = string
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
  type        = string
  default     = null
}
