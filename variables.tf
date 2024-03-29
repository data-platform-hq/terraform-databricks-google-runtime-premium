variable "suffix" {
  description = "Resource name suffix"
  type        = string
  default     = ""
}

# Identity Access Management variables
variable "workspace_admins" {
  type = object({
    user              = optional(list(string))
    service_principal = optional(list(string))
    generate_token    = optional(bool) # Applyed only for service principal
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
    generate_token    = optional(bool) # Applyed only for service principal
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

variable "token_lifetime_seconds" {
  type        = number
  description = "The lifetime of the token, in seconds. If no lifetime is specified, the token remains valid indefinitely"
  default     = 315569520
}

# # Secret Scope variables
variable "secret_scope" {
  type = list(object({
    scope_name = string
    acl = optional(list(object({
      principal  = string
      permission = string
    })))
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
    secrets    = null
  }]
}

variable "custom_cluster_policies" {
  type = list(object({
    name       = string
    can_use    = list(string)
    definition = any
  }))
  description = <<-EOT
Provides an ability to create custom cluster policy, assign it to cluster and grant CAN_USE permissions on it to certain custom groups
name - name of custom cluster policy to create
can_use - list of string, where values are custom group names, there groups have to be created with Terraform;
definition - JSON document expressed in Databricks Policy Definition Language. No need to call 'jsonencode()' function on it when providing a value;
EOT
  default = [{
    name       = null
    can_use    = null
    definition = null
  }]
}

variable "clusters" {
  type = set(object({
    cluster_name                 = string
    runtime_engine               = optional(string)
    spark_version                = optional(string, "13.3.x-scala2.12")
    spark_conf                   = optional(map(any), {})
    spark_env_vars               = optional(map(any), {})
    data_security_mode           = optional(string, "USER_ISOLATION")
    node_type_id                 = optional(string, "")
    autotermination_minutes      = optional(number, 30)
    num_workers                  = optional(number)
    min_workers                  = optional(number, 1)
    max_workers                  = optional(number, 2)
    google_service_account       = optional(string, "")
    availability                 = optional(string, "PREEMPTIBLE_WITH_FALLBACK_GCP")
    boot_disk_size               = optional(number)
    local_ssd_count              = optional(number)
    zone_id                      = optional(string, "")
    cluster_log_conf_destination = optional(string, null)
    single_user_name             = optional(string, null)
    permissions = optional(set(object({
      group_name       = string
      permission_level = string
    })), [])
    pypi_library_repository = optional(set(string), [])
    maven_library_repository = optional(set(object({
      coordinates = string
      exclusions  = set(string)
    })), [])
  }))
  description = "Set of objects with parameters to configure Databricks clusters and assign permissions to it for certain custom groups"
  default     = []
}

# SQL Warehouse variables
variable "sql_endpoint" {
  type = set(object({
    name                 = string
    cluster_size         = optional(string, "2X-Small")
    min_num_clusters     = optional(number, 0)
    max_num_clusters     = optional(number, 1)
    auto_stop_mins       = optional(string, "30")
    enable_photon        = optional(bool, false)
    spot_instance_policy = optional(string, "RELIABILITY_OPTIMIZED")
    warehouse_type       = optional(string, "PRO")
    permissions = optional(set(object({
      group_name       = string
      permission_level = string
    })), [])
  }))
  description = "Set of objects with parameters to configure SQL Endpoint and assign permissions to it for certain custom groups"
  default     = []
}

variable "sql_global_config" {
  type = object({
    security_policy            = optional(string)
    data_access_config         = optional(map(any))
    sql_google_service_account = optional(string)
    sql_config_params          = optional(map(any))
  })
  description = "Parameters to configure the security policy, databricks_instance_profile, and data access properties for all databricks_sql_endpoint of workspace"
  default     = null
}


# Mount Google Cloud Storage Filesystem
variable "mount_enabled" {
  type        = bool
  description = "Boolean flag that determines whether mount point for storage bucket is created"
  default     = false
}

variable "mount_name" {
  description = "Full Google Storage mount name"
  type        = string
  default     = ""
}
variable "mount_bucket_name" {
  description = "Full Google Storage mounted bucket name"
  type        = string
  default     = ""
}

variable "mount_service_account" {
  description = "email of registered Google Service Account for mounted bucket data access"
  type        = string
  default     = ""
}

variable "mount_cluster_name" {
  type        = string
  description = "Name of the cluster that will be used during storage mounting"
  default     = null
}
