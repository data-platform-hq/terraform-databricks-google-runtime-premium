# variable "suffix" {
#   type        = string
#   description = "Optional suffix that would be added to the end of resources names."
#   default     = ""
# }

# # Identity Access Management variables
# variable "user_object_ids" {
#   type        = map(string)
#   description = "Map of AD usernames and corresponding object IDs"
#   default     = {}
# }

variable "workspace_admins" {
  type = object({
    user              = list(string)
    service_principal = list(string)
  })
  description = "Provide users or service principals to grant them Admin permissions in Workspace."
  default = {
    user              = null
    service_principal = null
  }
}

variable "iam_account_groups" {
  type = list(object({
    group_name   = optional(string)
    entitlements = optional(list(string))
  }))
  description = "List of objects with group name and entitlements for this group"
  default     = []
}

variable "iam_workspace_groups" {
  type = map(object({
    user              = optional(list(string))
    service_principal = optional(list(string))
    entitlements      = optional(list(string))
  }))
  description = "Used to create workspace group. Map of group name and its parameters, such as users and service principals added to the group. Also possible to configure group entitlements."
  default     = {}

  validation {
    condition = length([for item in values(var.iam_workspace_groups)[*] : item.entitlements if item.entitlements != null]) != 0 ? alltrue([
      for entry in flatten(values(var.iam_workspace_groups)[*].entitlements) : contains(["allow_cluster_create", "allow_instance_pool_create", "databricks_sql_access"], entry) if entry != null
    ]) : true
    error_message = "Entitlements validation. The only suitable values are: databricks_sql_access, allow_instance_pool_create, allow_cluster_create"
  }
}

# # SQL Endpoint variables
# variable "sql_endpoint" {
#   type = set(object({
#     name                      = string
#     cluster_size              = optional(string, "2X-Small")
#     min_num_clusters          = optional(number, 0)
#     max_num_clusters          = optional(number, 1)
#     auto_stop_mins            = optional(string, "30")
#     enable_photon             = optional(bool, false)
#     enable_serverless_compute = optional(bool, false)
#     spot_instance_policy      = optional(string, "COST_OPTIMIZED")
#     warehouse_type            = optional(string, "PRO")
#     permissions = optional(set(object({
#       group_name       = string
#       permission_level = string
#     })), [])
#   }))
#   description = "Set of objects with parameters to configure SQL Endpoint and assign permissions to it for certain custom groups"
#   default     = []
# }

# variable "sp_client_id_secret_name" {
#   type        = string
#   description = "The name of Azure Key Vault secret that contains ClientID of Service Principal to access in Azure Key Vault"
# }

# variable "sp_key_secret_name" {
#   type        = string
#   description = "The name of Azure Key Vault secret that contains client secret of Service Principal to access in Azure Key Vault"
# }

# # Secret Scope variables
variable "secret_scope" {
  type = list(object({
    scope_name = string
    # acl = optional(list(object({
    #   principal  = string
    #   permission = string
    # })))
    secrets = optional(list(object({
      key          = string
      string_value = string
    })))
  }))
  description = <<-EOT
Provides an ability to create custom Secret Scope, store secrets in it and assigning ACL for access management
scope_name - name of Secret Scope to create;
acl - list of objects, where 'principal' custom group name, this group is created in 'Premium' module; 'permission' is one of "READ", "WRITE", "MANAGE";
secrets - list of objects, where object's 'key' param is created key name and 'string_value' is a value for it;
EOT
  default = [{
    scope_name = null
    # acl        = null
    secrets = null
  }]
}
