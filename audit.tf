#
# Audit and logs
#
data "azurerm_storage_account" "audit_storage" {
  resource_group_name = replace(var.audit_storage_account_id, "resourceGroups/(.*?)/", "$1")
  name                = replace(var.audit_storage_account_id, "storageAccounts/(.*?)(?:$|/$)", "$1")
}

resource "azurerm_synapse_workspace_extended_auditing_policy" "this" {
  synapse_workspace_id       = azurerm_synapse_workspace.this.id
  storage_endpoint           = data.azurerm_storage_account.audit_storage.primary_blob_endpoint
  retention_in_days          = var.audit_retention_in_days
  storage_account_access_key = data.azurerm_storage_account.audit_storage.primary_access_key
  log_monitoring_enabled     = var.audit_log_monitoring_enabled
}

resource "azurerm_synapse_workspace_security_alert_policy" "this" {
  count = var.alert_policy == null ? 0 : 1

  synapse_workspace_id         = azurerm_synapse_workspace.this.id
  policy_state                 = var.alert_policy.state
  disabled_alerts              = var.alert_policy.disabled_alerts
  email_account_admins_enabled = var.alert_policy.email_account_admins_enabled
  email_addresses              = var.alert_policy.alert_email_addresses
  retention_days               = var.alert_policy.retention_days
  storage_account_access_key   = data.azurerm_storage_account.audit_storage.primary_access_key
  storage_endpoint             = data.azurerm_storage_account.audit_storage.primary_blob_endpoint
}

resource "azurerm_synapse_workspace_vulnerability_assessment" "this" {
  count = var.alert_policy == null ? 0 : 1

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
  name                           = "ds-${azurerm_synapse_workspace.this.name}"
  target_resource_id             = azurerm_synapse_workspace.this.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_log_categories)
    content {
      category = enabled_log.value.category
      dynamic "retention_policy" {
        for_each = [lookup(enabled_log.value, "retention_policy", null)]

        content {
          enabled = retention_policy.value.enabled
          days    = lookup(retention_policy.value, "days", 0)
        }
      }
    }
  }
  dynamic "metric" {
    for_each = toset(var.diagnostic_setting_metric_categories)
    content {
      category = metric.value.category
      dynamic "retention_policy" {
        for_each = [lookup(metric.value, "retention_policy", null)]

        content {
          enabled = retention_policy.value.enabled
          days    = lookup(retention_policy.value, "days", 0)
        }
      }
    }
  }
}
