resource "databricks_cluster" "cluster" {
  for_each = { for cluster in var.clusters : cluster.cluster_name => cluster }

  cluster_name            = each.value.cluster_name
  spark_version           = each.value.spark_version
  spark_conf              = each.value.spark_conf
  spark_env_vars          = each.value.spark_env_vars
  data_security_mode      = each.value.data_security_mode
  node_type_id            = each.value.node_type_id
  autotermination_minutes = each.value.autotermination_minutes
  single_user_name        = each.value.single_user_name

  autoscale {
    min_workers = each.value.min_workers
    max_workers = each.value.max_workers
  }

  gcp_attributes {
    availability = each.value.availability
    zone_id      = each.value.zone_id
  }

  dynamic "cluster_log_conf" {
    for_each = each.value.cluster_log_conf_destination != null ? [each.value.cluster_log_conf_destination] : []
    content {
      dbfs {
        destination = cluster_log_conf.value
      }
    }
  }

  dynamic "library" {
    for_each = each.value.pypi_library_repository
    content {
      pypi {
        package = library.value
      }
    }
  }

  dynamic "library" {
    for_each = each.value.maven_library_repository
    content {
      maven {
        coordinates = library.value.coordinates
        exclusions  = library.value.exclusions
      }
    }
  }

  lifecycle {
    ignore_changes = [
      state
    ]
  }
}

resource "databricks_cluster_policy" "this" {
  for_each = {
    for param in var.custom_cluster_policies : (param.name) => param.definition
    if param.definition != null
  }

  name       = each.key
  definition = jsonencode(each.value)
}
