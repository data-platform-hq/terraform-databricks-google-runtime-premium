locals {

  suffix = length(var.suffix) == 0 ? "" : "-${var.suffix}"

  token_list = toset(flatten(concat(
    values({ for group, member in var.iam_workspace_groups : group => member.service_principal
    if alltrue([member.service_principal != null, member.generate_token]) }),

    values(alltrue([var.workspace_admins.service_principal != null, var.workspace_admins.generate_token]) ? {
      for sp in var.workspace_admins.service_principal : "service_principal.${sp}" => sp
    } : {})
  )))

}

resource "databricks_permissions" "token_usage" {
  count = length(local.token_list) != 0 ? 1 : 0


  authorization = "tokens"
  dynamic "access_control" {
    for_each = local.token_list
    content {
      service_principal_name = databricks_service_principal.this[access_control.key].application_id
      permission_level       = "CAN_USE"
    }
  }
}

resource "databricks_obo_token" "this" {
  for_each = local.token_list

  application_id   = databricks_service_principal.this[each.key].application_id
  comment          = "PAT on behalf of ${databricks_service_principal.this[each.key].display_name}"
  lifetime_seconds = var.token_lifetime_seconds

  depends_on = [databricks_permissions.token_usage]
}

## SQL Endpoint
resource "databricks_sql_endpoint" "this" {
  for_each = { for endpoint in var.sql_endpoint : (endpoint.name) => endpoint }

  name                 = "${each.key}${local.suffix}"
  cluster_size         = each.value.cluster_size
  min_num_clusters     = each.value.min_num_clusters
  max_num_clusters     = each.value.max_num_clusters
  auto_stop_mins       = each.value.auto_stop_mins
  enable_photon        = each.value.enable_photon
  spot_instance_policy = each.value.spot_instance_policy
  warehouse_type       = each.value.warehouse_type

  lifecycle {
    ignore_changes = [state, num_clusters]
  }
  depends_on = [databricks_sql_global_config.this]
}

resource "databricks_sql_global_config" "this" {
  security_policy        = var.security_policy
  data_access_config     = var.data_access_config
  google_service_account = var.google_service_account
  sql_config_params      = var.sql_config_params
}
