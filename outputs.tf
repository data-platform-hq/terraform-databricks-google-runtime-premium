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

output "sql_endpoint_data_source_id" {
  value       = [for n in databricks_sql_endpoint.this : n.data_source_id]
  description = "ID of the data source for this endpoint"
}

output "sql_endpoint_jdbc_url" {
  value       = [for n in databricks_sql_endpoint.this : n.jdbc_url]
  description = "JDBC connection string of SQL Endpoint"
}
