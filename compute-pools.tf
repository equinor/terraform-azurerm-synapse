###
### Compute Pools
###
resource "azurerm_synapse_spark_pool" "this" {
  for_each = { for spark_pool in var.spark_pools : spark_pool.name => spark_pool }

  name                 = each.value.name
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  node_size_family     = each.value.node_size_family
  node_size            = each.value.node_size
  node_count           = each.value.auto_scale != null ? null : each.value.node_count
  auto_pause {
    delay_in_minutes = each.value.auto_pause_delay_in_minutes
  }

  dynamic "auto_scale" {
    for_each = each.value.auto_scale != null ? [each.value.auto_scale] : []
    content {
      max_node_count = auto_scale.value.max_node_count
      min_node_count = auto_scale.value.min_node_count
    }
  }
  cache_size                          = each.value.cache_size
  compute_isolation_enabled           = each.value.compute_isolation_enabled
  dynamic_executor_allocation_enabled = each.value.dynamic_executor_allocation_enabled
  min_executors                       = each.value.min_executors
  max_executors                       = each.value.max_executors
  dynamic "library_requirement" {
    for_each = each.value.library_requirement != null ? [each.value.library_requirement] : []
    content {
      content  = library_requirement.value.content
      filename = library_requirement.value.filename
    }
  }
  session_level_packages_enabled = each.value.session_level_packages_enabled
  dynamic "spark_config" {
    for_each = each.value.spark_config != null ? [each.value.spark_config] : []
    content {
      content  = spark_config.value.content
      filename = spark_config.value.filename
    }
  }
  spark_log_folder    = each.value.spark_log_folder
  spark_events_folder = each.value.spark_events_folder
  spark_version       = each.value.spark_version

  tags = each.value.tags
}

module "sql_pool" {
  source   = "./modules/sql_pool"
  for_each = var.sql_pools

  name                      = each.value.name
  workspace_id              = azurerm_synapse_workspace.this.id
  sku_name                  = each.value.sku_name
  create_mode               = each.value.create_mode
  collation                 = each.value.collation
  data_encrypted            = each.value.data_encrypted
  recovery_database_id      = each.value.recovery_database_id
  restore                   = each.value.restore
  geo_backup_policy_enabled = each.value.geo_backup_policy_enabled
  tags                      = each.value.tags

  audit_storage_account_name           = data.azurerm_storage_account.audit_storage.name
  audit_storage_account_resource_group = data.azurerm_storage_account.audit_storage.resource_group_name
  audit_retention_in_days              = each.value.audit_retention_in_days
  audit_log_monitoring_enabled         = each.value.audit_log_monitoring_enabled
  alert_policy_state                   = each.value.alert_policy_state
  disabled_alerts                      = each.value.disabled_alerts
  alert_account_admins_email           = each.value.alert_account_admins_email
  alert_email_addresses                = each.value.alert_email_addresses
  alert_retention_days                 = each.value.alert_retention_days

  recurring_scans                    = each.value.recurring_scans
  vulnerability_assessment_baselines = each.value.vulnerability_assessment_baselines

  workload_groups = each.value.workload_groups
}
