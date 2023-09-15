locals {

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
