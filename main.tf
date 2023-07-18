resource "databricks_service_principal" "automation" {
  count = length(var.automation_sa) != 0 ? 1 : 0

  display_name = var.automation_sa
}

resource "databricks_permissions" "token_usage" {
  count = length(var.automation_sa) != 0 ? 1 : 0

  authorization = "tokens"
  access_control {
    service_principal_name = databricks_service_principal.automation[0].application_id
    permission_level       = "CAN_USE"
  }

  depends_on = [databricks_service_principal.automation]
}

resource "databricks_obo_token" "automation" {
  count = length(var.automation_sa) != 0 ? 1 : 0

  application_id   = databricks_service_principal.automation[0].application_id
  comment          = "PAT on behalf of ${databricks_service_principal.automation[0].display_name}"
  lifetime_seconds = var.token_lifetime_seconds

  depends_on = [databricks_permissions.token_usage]
}
