output "pool_id" {
  description = "The ID of this Spark Pool."
  # Conditionally output based on auto scale rules
  value = var.auto_scale_max_node_count != null ? azurerm_synapse_spark_pool.auto_scale[0].id : azurerm_synapse_spark_pool.static_nodes[0].id
}

output "diagnostic_setting_id" {
  description = "The ID of this diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}
