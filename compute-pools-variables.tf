variable "spark_pools" {
  description = "A list of Sprak pools to create."
  type = list(object({
    name : string
    node_size_family : string
    node_size : string
    node_count : optional(number, null)
    auto_pause_delay_in_minutes : optional(number, 5)
    auto_scale : optional(object({
      max_node_count : number
      min_node_count : number
    }), null)
    cache_size : optional(number, null)
    compute_isolation_enabled : optional(bool, false)
    dynamic_executor_allocation_enabled : optional(bool, true)
    min_executors : optional(number, 1)
    max_executors : optional(number, 2)
    library_requirement : optional(object({
      content : string
      filename : string
    }), null)
    session_level_packages_enabled : optional(bool, false)
    spark_config : optional(object({
      content : string
      filename : string
    }), null)
    spark_log_folder : optional(string, null)
    spark_events_folder : optional(string, null)
    spark_version : optional(string, null)
    tags : optional(map(string), null)
  }))
  default = []
}

variable "sql_pools" {
  description = "A list of sql pools to create."
  type = set(object({
    name : string
    sku_name : string
    create_mode : optional(string, "Default")
    collation : optional(string, "SQL_LATIN1_GENERAL_CP1_CI_AS")
    data_encrypted : optional(string, true)
    recovery_database_id : optional(string, null)
    restore : optional(object({
      source_database_id : string
      point_in_time : string
    }), null)
    geo_backup_policy_enabled : optional(bool, true)
    tags : optional(map(string), null)

    audit_retention_in_days : optional(number, 0)
    audit_log_monitoring_enabled : optional(bool, true)
    alert_policy_state : optional(string, "Enabled")
    disabled_alerts : optional(list(string), [])
    alert_account_admins_email : optional(bool, false)
    email_addresses : optional(list(string), [])
    alert_retention_days : optional(number, 0)

    recurring_scans : optional(list(object({
      enabled : optional(bool, true)
      email_subcription_admins_enabled : optional(bool, true)
      emails : optional(list(string), [])
    })), null)
    vulnerability_assessment_baselines : optional(list(object({
      name : string
      rule_id : string
      baselines : optional(list(object({
        result : list(string)
      })), [])
    })), null)

    workload_groups : optional(list(object({})), null)
  }))
  default = []
}
