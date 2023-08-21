output "token" {
  value       = length(var.automation_sa) != 0 ? databricks_obo_token.automation[0].token_value : null
  description = "Databricks On-Behalf-Of Authorization Token"
  sensitive   = true
}
