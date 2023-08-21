# Google Databricks premium Runtime Terraform module
Terraform module for creation Google Databricks premium Runtime

## Usage

<!-- BEGIN_TF_DOCS -->
## Requirements
| Name                                                                         | Version   |
|------------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | >= 1.0.0  |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.19.0 |

## Providers
| Name                                                                   | Version |
|------------------------------------------------------------------------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.19.0  |

## Modules
No modules.

## Resources
| Name                                                                                                                                             | Type     |
|--------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [databricks_group.account_groups](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group)                  | data     |
| [databricks_group.admin](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group)                           | data     |
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group)                               | resource |
| [databricks_user.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/user)                                 | resource |
| [databricks_service_principal.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal)       | resource |
| [databricks_group_member.admin](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)                | resource |
| [databricks_group_member.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)                 | resource |
| [databricks_entitlements.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/entitlements)                 | resource |
| [databricks_service_principal.automation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal) | resource |
| [databricks_permissions.token_usage](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions)            | resource |
| [databricks_obo_token.automation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/obo_token)                 | resource |
| [databricks_secret_scope.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_scope)                 | resource |
| [databricks_secret.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret)                             | resource |


## Inputs
| Name                                                                                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                | Type             | Default                                                        | Required |
|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|----------------------------------------------------------------|:--------:|
| <a name="input_workspace_admins"></a> [workspace\_admins](#input\_workspace\_admins)                     | Provide users or service principals to grant them Admin permissions in Workspace                                                                                                                                                                                                                                                                                                                                                           | ` object`        | {}                                                             |   yes    |
| <a name="input_iam_account_groups"></a> [iam\_account\_groups](#input\_iam\_account\_groups)             | List of objects with group name and entitlements for this group                                                                                                                                                                                                                                                                                                                                                                            | `list(object)`   | [{}]                                                           |   yes    |
| <a name="input_iam_workspace_groups"></a> [iam\_workspace\_groups](#input\_iam\_workspace\_groups)       | Used to create workspace group. Map of group name and its parameters, such as users and service principals added to the group. Also possible to configure group entitlements                                                                                                                                                                                                                                                               | `map(object({})` | {}                                                             |   yes    |
| <a name="input_automation_sa"></a> [automation\_sa](#input\_automation\_sa)                              | Name for automation service principal to be created for this Workspace. A databricks_obo_token will also be generated                                                                                                                                                                                                                                                                                                                      | `string`         | n/a                                                            |   yes    |
| <a name="input_token_lifetime_seconds"></a> [token\_lifetime\_seconds](#input\_token\_lifetime\_seconds) | The lifetime of the token, in seconds. If no lifetime is specified, the token remains valid indefinitely                                                                                                                                                                                                                                                                                                                                   | `number`         | 315569520                                                      |    no    |
| <a name="input_secret_scope"></a> [secret\_scope](#input\_secret\_scope)                                 | Provides an ability to create custom Secret Scope, store secrets in it and assigning ACL for access management scope_name - name of Secret Scope to create;<br>acl - list of objects, where 'principal' custom group name, this group is created in 'Premium' module; 'permission' is one of "READ", "WRITE", "MANAGE";<br>secrets - list of objects, where object's 'key' param is created key name and 'string_value' is a value for it; | `list(object)`   | <pre>[{<br>  scope_name = null<br>  secrets = null<br>}]</pre> |    no    |


## Outputs
| Name                                         | Description                                         |
|----------------------------------------------|-----------------------------------------------------|
| <a name="token"></a> [token](#output\_token) | Databricks Personal Authorization Token (sensitive) |

<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-google-runtime-premium/blob/main/LICENSE)
