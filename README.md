<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Azure Key Vault Terraform module](#azure-key-vault-terraform-module)
  - [User Stories for this module](#user-stories-for-this-module)
  - [Usage](#usage)
  - [Examples](#examples)
  - [Modules](#modules)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Azure Key Vault Terraform module

Terraform module which creates a Key Vault resource on Azure.

## User Stories for this module

- AAOPS I have a Key Vault that allows me to store secrets
- AAOPS I have a Key Vault that allows me to store certificates

## Usage

```hcl
module "key_vault" {
  source = "git@github.com/padok-team/terraform-azurerm-keyvault"

  name                = "my_key_vault"
  resource_group_name = "my_rg"
  sku_name            = "standard"

  tags = {
    terraform = "true"
    padok     = "library"
  }
}
```

## Examples

- [Example of simple secure keyvault](examples/simple_secure_keyvault/main.tf)
- [Example of keyvault with tags and nacls](examples/keyvault_with_tags_and_nacls/main.tf)
- [Example of keyvault without an ACL](examples/keyvault_without_acl/main.tf)
- [Example of keyvault with a private endpoint](examples/keyvault_with_private_endpoint/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logger"></a> [logger](#module\_logger) | git@github.com:padok-team/terraform-azurerm-logger.git | v0.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Key Vault. Vault names are globaly unique. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group configuration. | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |
| <a name="input_access_policy"></a> [access\_policy](#input\_access\_policy) | List of policies to access the Key Vault. | <pre>map(object({<br>    application_id          = optional(string)<br>    certificate_permissions = optional(list(string))<br>    key_permissions         = optional(list(string))<br>    secret_permissions      = optional(list(string))<br>    storage_permissions     = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_enable_network_acl"></a> [enable\_network\_acl](#input\_enable\_network\_acl) | Boolean flag to enable or not network acl. | `bool` | `true` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | The logging configuration | <pre>object({<br>    enabled                    = bool,<br>    log_analytics_workspace_id = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "log_analytics_workspace_id": null<br>}</pre> | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network acls to deploy on the key vault. ip\_rules is a list of IP or CIDR blocks. | <pre>object({<br>    ip_rules                   = list(string)<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | <pre>{<br>  "ip_rules": [],<br>  "virtual_network_subnet_ids": []<br>}</pre> | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | The private endpoint configuration. | <pre>object({<br>    enable              = bool,<br>    subnet_id           = string<br>    private_dns_zone_id = string,<br>  })</pre> | <pre>{<br>  "enable": false,<br>  "private_dns_zone_id": null,<br>  "subnet_id": null<br>}</pre> | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `string` | `"90"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The key vault ID. |
| <a name="output_name"></a> [name](#output\_name) | The key vault name. |
| <a name="output_private_endpoint"></a> [private\_endpoint](#output\_private\_endpoint) | The private endpoint instance. |
| <a name="output_this"></a> [this](#output\_this) | The key vault. |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
