locals {
  secrets_objects_list = flatten([for param in var.secret_scope : [
    for secret in param.secrets : {
      scope_name = param.scope_name, key = secret.key, string_value = secret.string_value
    }] if param.secrets != null
  ])
}

resource "databricks_secret_scope" "this" {
  for_each = {
    for param in var.secret_scope : (param.scope_name) => param
    if param.scope_name != null
  }

  name         = each.key
  backend_type = "DATABRICKS"
}

resource "databricks_secret" "this" {
  for_each = { for entry in local.secrets_objects_list : "${entry.scope_name}.${entry.key}" => entry }

  key          = each.value.key
  string_value = each.value.string_value
  scope        = databricks_secret_scope.this[each.value.scope_name].id

  depends_on = [databricks_secret_scope.this]

}

resource "databricks_secret_acl" "this" {
  for_each = { for entry in local.secrets_acl_objects_list : "${entry.scope}.${entry.principal}.${entry.permission}" => entry }

  scope      = databricks_secret_scope.this[each.value.scope].name
  principal  = length(var.iam_account_groups) != 0 ? data.databricks_group.account_groups[each.value.principal].display_name : databricks_group.this[each.value.principal].display_name
  permission = each.value.permission

  lifecycle {
    precondition {
      condition     = length(var.iam_account_groups) != 0 ? contains(var.iam_account_groups[*].group_name, each.value.principal) : true
      error_message = <<-EOT
      Databricks Account group mentioned in 'acl' parameter of 'secret_scope' variable doesn't exists or wasn't assigned to Workspace.
      Please make sure provided group exist within Databricks Account and then check if it assigned to target Workspace (look for 'iam_account_groups' variable).
      These are valid Account Groups on Workspace: ${join(", ", var.iam_account_groups[*].group_name)}
      EOT
    }
  }
}
