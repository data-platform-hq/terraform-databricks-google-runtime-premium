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
| [databricks_permissions.token_usage](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions)            | resource |
| [databricks_obo_token.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/obo_token)                 | resource |
| [databricks_secret_scope.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_scope)                 | resource |
| [databricks_secret.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret)                             | resource |
| [databricks_cluster.cluster](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster#gcp_attributes)         | resource |
| [databricks_cluster_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy)             | resource |


## Inputs
| Name                                                                                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                | Type             | Default                                                        | Required |
|----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|----------------------------------------------------------------|:--------:|
| <a name="input_workspace_admins"></a> [workspace\_admins](#input\_workspace\_admins)                     | Provide users or service principals to grant them Admin permissions in Workspace                                                                                                                                                                                                                                                                                                                                                           | ` object`        | {}                                                             |   no    |
| <a name="input_iam_account_groups"></a> [iam\_account\_groups](#input\_iam\_account\_groups)             | List of objects with group name and entitlements for this group                                                                                                                                                                                                                                                                                                                                                                            | `list(object)`   | [{}]                                                           |   no    |
| <a name="input_iam_workspace_groups"></a> [iam\_workspace\_groups](#input\_iam\_workspace\_groups)       | Used to create workspace group. Map of group name and its parameters, such as users and service principals added to the group. Also possible to configure group entitlements                                                                                                                                                                                                                                                               | `map(object({})` | {}                                                             |   no    |
| <a name="input_token_lifetime_seconds"></a> [token\_lifetime\_seconds](#input\_token\_lifetime\_seconds) | The lifetime of the token, in seconds. If no lifetime is specified, the token remains valid indefinitely                                                                                                                                                                                                                                                                                                                                   | `number`         | `315569520`                                                      |    no    |
| <a name="input_secret_scope"></a> [secret\_scope](#input\_secret\_scope)                                 | Provides an ability to create custom Secret Scope, store secrets in it and assigning ACL for access management scope_name - name of Secret Scope to create;<br>acl - list of objects, where 'principal' custom group name, this group is created in 'Premium' module; 'permission' is one of "READ", "WRITE", "MANAGE";<br>secrets - list of objects, where object's 'key' param is created key name and 'string_value' is a value for it; | `list(object)`   | <pre>[{<br>  scope_name = null<br>  secrets = null<br>}]</pre> |    no    |
| <a name="input_custom_cluster_policies"></a> [custom\_cluster\_policies](#input\_custom\_cluster\_policies)                                 | Provides an ability to create custom cluster policy, assign it to cluster and grant CAN_USE permissions on it to certain custom groups name - name of custom cluster policy to create can_use - list of string, where values are custom group names, there groups have to be created with Terraform; definition - JSON document expressed in Databricks Policy Definition Language. No need to call 'jsonencode()' function on it when providing a value; | `list(object)`   | <pre>list(object({<br>  name       = string<br>  can_use    = list(string)<br>  definition = any<br>}))<br></pre> |    no    |
| <a name="input_clusters"></a> [clusters](#input\_clusters)                                                                         | Set of objects with parameters to configure Databricks clusters and assign permissions to it for certain custom groups                                                                                                                                                                                                                                                                    | set(object({})| <pre>set(object({<br>    cluster_name                 = string<br>    spark_version                = optional(string, "13.3.x-scala2.12")<br>    spark_conf                   = optional(map(any), {})<br>    spark_env_vars               = optional(map(any), {})<br>    data_security_mode           = optional(string, "USER_ISOLATION")<br>    node_type_id                 = optional(string, "")<br>    autotermination_minutes      = optional(number, 30)<br>    min_workers                  = optional(number, 1)<br>    max_workers                  = optional(number, 2)<br>    availability                 = optional(string, "PREEMPTIBLE_WITH_FALLBACK_GCP")<br>    first_on_demand              = optional(number, 0)<br>    spot_bid_max_price           = optional(number, 1)<br>    cluster_log_conf_destination = optional(string, null)<br>    single_user_name             = optional(string, null)<br>    permissions = optional(set(object({<br>      group_name       = string<br>      permission_level = string<br>    })), [])<br>    pypi_library_repository = optional(set(string), [])<br>    maven_library_repository = optional(set(object({<br>      coordinates = string<br>      exclusions  = set(string)<br>   })), [])<br>}))<br></pre> |    no    |

## Outputs
| Name                                         | Description                                         |
|----------------------------------------------|-----------------------------------------------------|
| <a name="token"></a> [token](#output\_token) | Databricks Personal Authorization Token (sensitive) |
| <a name="clusters"></a> [clusters](#output\_clusters) | Provides name and unique identifier for the clusters |

<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-google-runtime-premium/blob/main/LICENSE)
