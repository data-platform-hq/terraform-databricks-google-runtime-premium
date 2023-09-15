output "token" {
  value       = { for k, v in local.token_list : k => databricks_obo_token.this[k].token_value if local.token_list != null }
  description = "Databricks Personal Authorization Tokens"
  sensitive   = true
}

output "clusters" {
  value = [for param in var.clusters : {
    name = param.cluster_name
    id   = databricks_cluster.cluster[param.cluster_name].id
  } if length(var.clusters) != 0]
  description = "Provides name and unique identifier for the clusters"
}
