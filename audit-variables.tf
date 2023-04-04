variable "audit_storage_account_id" {
  description = "Resource Id for a storage account to store audit logs in."
  type        = string
  default     = null
}

variable "audit_storage_account_name" {
  description = "Name of the audit storage account. Will not be used if audit storage account id is given."
  type        = string
  default     = null
}

variable "audit_log_monitoring_enabled" {
  description = "Enables or disabled audit log monitorng."
  type        = bool
  default     = true
}

variable "audit_retention_in_days" {
  description = "Number of days to store audit logs. defaults to 0 which means indefinetly"
  type        = number
  default     = 0
}

variable "alert_policy" {
  description = "Alert policy settings for the workspace"
  type = object({
    state                        = optional(string, "Enabled")
    disabled_alerts              = optional(list(string), [])
    email_account_admins_enabled = optional(bool, false)
    alert_email_addresses        = optional(list(string), [])
    retention_days               = optional(number, 0)
  })

  default = null
}

variable "recurring_vulnerability_scans_enabled" {
  description = "Should recuring vulnerability scans be enabled for the workspace?"
  type        = bool
  default     = true
}

variable "vulnerability_scans_admin_email_notification_enabled" {
  description = "Should workspace admin get email notification with scan results?"
  type        = bool
  default     = false
}

variable "vulnerability_scans_emails" {
  description = "List of emails that should recieve scan notifications."
  type        = list(string)
  default     = []
}
variable "diagnostic_setting_log_categories" {
  description = "A list of log categories to be set for this diagnostic setting."
  type = list(object({
    category : string
    retention_policy : optional(object({
      enabled : optional(bool, true)
      days : optional(string, 0)
    }), null)
  }))

  default = [
    { category : "GatewayApiRequests" },
    { category : "SynapseRbacOperations" },
    { category : "BuiltinSqlReqsEnded" },
    { category : "SQLSecurityAuditEvents" },
    { category : "SynapseLinkEvent" },
    { category : "IntegrationPipelineRuns" },
    { category : "IntegrationActivityRuns" },
    { category : "IntegrationTriggerRuns" }
  ]
}

variable "diagnostic_setting_metric_categories" {
  description = "A list of metric categories to be set for this diagnostic setting."
  type = list(object({
    category : string
    retention_policy : optional(object({
      enabled : optional(bool, true)
      days : optional(string, 0)
    }), null)
  }))

  default = [
    { category : "AllMetrics" }
  ]
}
