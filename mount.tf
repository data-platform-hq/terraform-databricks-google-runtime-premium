##  Mounting cloud object storage to the Databricks File System (DBFS) disabled by default.
# You should set variable "mount_enabled" true to enable.
# If you decide to destroy Databricks infrastructure we highly recommend:
#  - disable "Mount" (mount_enabled=false)
#  - run "terraform apply"
#  - "terraform destroy"
resource "databricks_mount" "gs" {
  count = var.mount_enabled ? 1 : 0

  name = var.mount_name
  gs {
    service_account = var.mount_service_account
    bucket_name     = var.mount_bucket_name
  }
  cluster_id = var.mount_cluster_name != null ? databricks_cluster.cluster[var.mount_cluster_name].id : null
}
