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
  count = var.sql_global_config == null ? 0 : 1

  security_policy        = var.sql_global_config.security_policy
  data_access_config     = var.sql_global_config.data_access_config
  google_service_account = var.sql_global_config.sql_google_service_account
  sql_config_params      = var.sql_global_config.sql_config_params
}
