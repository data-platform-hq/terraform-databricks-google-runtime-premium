terraform {
  required_version = ">= 1.0.0"

  required_providers {

    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.19.0"
    }

  }
}

# provider "databricks" {
#   alias                  = "workspace"
#   host                   = module.databricks_ws.workspace_url
#   google_service_account = var.google_service_account_email
# }
