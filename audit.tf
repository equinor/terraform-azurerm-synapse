#
# Audit and logs
#
locals {
  audit_storage = regex("resourceGroups/(?P<resource_group_name>.*?)/.*?/storageAccounts/(?P<storage_account_name>.*?)(?:$|/$)", var.audit_storage_account_id)
}
data "azurerm_storage_account" "audit_storage" {
  resource_group_name = local.audit_storage.resource_group_name
  name                = local.audit_storage.storage_account_name
}

# Add Contributor access for Synapse on the Audit account so it can write to it
resource "azurerm_role_assignment" "audit_storage" {
  scope                = data.azurerm_storage_account.audit_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.this.identity[0].principal_id
}

resource "azurerm_synapse_workspace_extended_auditing_policy" "this" {
  depends_on = [
    azurerm_role_assignment.audit_storage
  ]
  synapse_workspace_id   = azurerm_synapse_workspace.this.id
  storage_endpoint       = data.azurerm_storage_account.audit_storage.primary_blob_endpoint
  retention_in_days      = var.audit_retention_in_days
  log_monitoring_enabled = var.audit_log_monitoring_enabled
}

resource "azurerm_synapse_workspace_security_alert_policy" "this" {
  count = var.alert_policy == null ? 0 : 1

  depends_on = [
    azurerm_role_assignment.audit_storage
  ]
  synapse_workspace_id         = azurerm_synapse_workspace.this.id
  policy_state                 = var.alert_policy.state
  disabled_alerts              = var.alert_policy.disabled_alerts
  email_account_admins_enabled = var.alert_policy.email_account_admins_enabled
  email_addresses              = var.alert_policy.alert_email_addresses
  retention_days               = var.alert_policy.retention_days
  storage_endpoint             = data.azurerm_storage_account.audit_storage.primary_blob_endpoint
}

resource "azurerm_synapse_workspace_vulnerability_assessment" "this" {
  count = var.alert_policy == null ? 0 : 1

  depends_on = [
    azurerm_role_assignment.audit_storage
  ]
  workspace_security_alert_policy_id = azurerm_synapse_workspace_security_alert_policy.this[0].id
  storage_container_path             = "${(data.azurerm_storage_account.audit_storage.primary_blob_endpoint)}${azurerm_synapse_workspace.this.name}-VaScans"
  storage_account_access_key         = data.azurerm_storage_account.audit_storage.primary_access_key
  recurring_scans {
    enabled                           = var.recurring_vulnerability_scans_enabled
    email_subscription_admins_enabled = var.vulnerability_scans_admin_email_notification_enabled
    emails                            = var.vulnerability_scans_emails
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "ds-${azurerm_synapse_workspace.this.name}"
  target_resource_id         = azurerm_synapse_workspace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_log_categories)
    content {
      category = enabled_log.value.category
    }
  }
  dynamic "metric" {
    for_each = toset(var.diagnostic_setting_metric_categories)
    content {
      category = metric.value.category

    }
  }
}
