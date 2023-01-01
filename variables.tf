variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Resource group configuration."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
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
  description = "Network acls to deploy on the key vault. ip_rules is a list of IP or CIDR blocks."
  default = {
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

variable "enable_network_acl" {
  type        = bool
  description = "Boolean flag to enable or not network acl."
  default     = true
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

# Resource : azurerm_key_vault_access_policy

# object_id => The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.
# application_id => The object ID of an Application in Azure Active Directory, if relevant.
# certificate_permissions => List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.
# key_permissions => List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify and WrapKey.
# secret_permissions => List of secret permissions, must be one or more from the following: Backup, Delete, get, list, purge, recover, restore and set.
# storage_permissions => List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update.
variable "access_policy" {
  type = map(object({
    application_id          = optional(string)
    certificate_permissions = optional(list(string))
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    storage_permissions     = optional(list(string))
  }))
  description = "List of policies to access the Key Vault."
  default     = {}
}

variable "private_endpoint" {
  description = "The private endpoint configuration."
  type = object({
    enable              = bool,
    subnet_id           = string
    private_dns_zone_id = string,
  })
  default = {
    enable              = false
    subnet_id           = null
    private_dns_zone_id = null
  }
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
