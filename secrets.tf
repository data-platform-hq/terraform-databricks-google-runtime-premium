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

# TODO: Secrets ACL's
