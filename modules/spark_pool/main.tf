#
# The spark pool if using auto scale
#
resource "azurerm_synapse_spark_pool" "auto_scale" {
  count                = var.auto_scale_max_node_count != null ? 1 : 0
  name                 = var.name
  synapse_workspace_id = var.synapse_workspace_id
  node_size_family     = var.node_size_family
  node_size            = var.node_size
  node_count           = var.auto_scale_max_node_count != null ? null : var.node_count

  auto_pause {
    delay_in_minutes = var.auto_pause_delay_in_minutes
  }

  dynamic "auto_scale" {
    for_each = var.auto_scale_max_node_count != null && var.auto_scale_min_node_count != null ? [{ max_node_count = var.auto_scale_max_node_count, min_node_count = var.auto_scale_min_node_count }] : []
    content {
      max_node_count = auto_scale.value.max_node_count
      min_node_count = auto_scale.value.min_node_count
    }
  }

  cache_size                          = var.cache_size
  compute_isolation_enabled           = var.compute_isolation_enabled
  dynamic_executor_allocation_enabled = var.dynamic_executor_allocation_enabled
  min_executors                       = var.min_executors
  max_executors                       = var.max_executors

  dynamic "library_requirement" {
    for_each = var.library_requirement_content != null && var.library_requirement_filename != null ? [{ content = var.library_requirement_content, filename = var.library_requirement_filename }] : []
    content {
      content  = library_requirement.value.content
      filename = library_requirement.value.filename
    }
  }

  session_level_packages_enabled = var.session_level_packages_enabled

  dynamic "spark_config" {
    for_each = var.spark_config_content != null && var.spark_config_filename != null ? [{ content = var.spark_config_content, filename = var.spark_config_filename }] : []
    content {
      content  = spark_config.value.content
      filename = spark_config.value.filename
    }
  }

  spark_log_folder    = var.spark_log_folder
  spark_events_folder = var.spark_events_folder
  spark_version       = var.spark_version

  tags = var.tags

  lifecycle {
    # Ignore changes to node count as this triggers as this is changed by synapse when running jobs
    ignore_changes = [node_count]
  }
}

#
# The spark pool if using static nodes
#
resource "azurerm_synapse_spark_pool" "static_nodes" {
  count = var.auto_scale_max_node_count != null ? 0 : 1

  name                 = var.name
  synapse_workspace_id = var.synapse_workspace_id
  node_size_family     = var.node_size_family
  node_size            = var.node_size
  node_count           = var.auto_scale_max_node_count != null ? null : var.node_count

  auto_pause {
    delay_in_minutes = var.auto_pause_delay_in_minutes
  }

  dynamic "auto_scale" {
    for_each = var.auto_scale_max_node_count != null && var.auto_scale_min_node_count != null ? [{ max_node_count = var.auto_scale_max_node_count, min_node_count = var.auto_scale_min_node_count }] : []
    content {
      max_node_count = auto_scale.value.max_node_count
      min_node_count = auto_scale.value.min_node_count
    }
  }

  cache_size                          = var.cache_size
  compute_isolation_enabled           = var.compute_isolation_enabled
  dynamic_executor_allocation_enabled = var.dynamic_executor_allocation_enabled
  min_executors                       = var.min_executors
  max_executors                       = var.max_executors

  dynamic "library_requirement" {
    for_each = var.library_requirement_content != null && var.library_requirement_filename != null ? [{ content = var.library_requirement_content, filename = var.library_requirement_filename }] : []
    content {
      content  = library_requirement.value.content
      filename = library_requirement.value.filename
    }
  }

  session_level_packages_enabled = var.session_level_packages_enabled

  dynamic "spark_config" {
    for_each = var.spark_config_content != null && var.spark_config_filename != null ? [{ content = var.spark_config_content, filename = var.spark_config_filename }] : []
    content {
      content  = spark_config.value.content
      filename = spark_config.value.filename
    }
  }

  spark_log_folder    = var.spark_log_folder
  spark_events_folder = var.spark_events_folder
  spark_version       = var.spark_version

  tags = var.tags

}


resource "azurerm_monitor_diagnostic_setting" "this" {
  name = "ds-${var.name}"
  # Conditionally select target based on autoscale settings
  target_resource_id         = var.auto_scale_max_node_count != null ? azurerm_synapse_spark_pool.auto_scale[0].id : azurerm_synapse_spark_pool.static_nodes[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_log_categories)
    content {
      category = enabled_log.value
    }
  }

  # NOTE: Metric logs are not currently availaible for export
  # ref: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-synapse-workspaces-bigdatapools-metrics
  lifecycle {
    # This is a temporary ignore change as the ds creates an empty
    # metric that is not usable
    ignore_changes = [metric]
  }
}
