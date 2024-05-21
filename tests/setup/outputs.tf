output "workspace_name" {
  value = "syn${local.name_suffix}"
}

output "spark_pool_name" {
  value = "sp${local.name_suffix}"
}

output "resource_group_name" {
  value = "rg-${local.name_suffix}"
}

output "location" {
  value = "northeurope"
}

output "log_analytics_workspace_id" {
  value = "/subscriptions/${random_uuid.subscription_id.result}/resourceGroups/${local.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/log-${local.name_suffix}"
}

output "audit_storage_account_id" {
  value = "/subscriptions/${random_uuid.subscription_id.result}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Storage/storageAccounts/staud${local.name_suffix}"
}

output "data_lake_gen2_id" {
  value = "/subscriptions/${random_uuid.subscription_id.result}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Storage/storageAccounts/dls${local.name_suffix}"
}
