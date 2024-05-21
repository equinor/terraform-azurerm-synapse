variable "name" {
  description = "The name for a Spark pool."
  type        = string
}

variable "synapse_workspace_id" {
  description = "The id of the synapse workspace this pool belongs to."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The id of a log analytics workspace."
  type        = string
}

variable "node_size_family" {
  description = "The node size family for a Spark pool. Possible values are 'HardwareAcceleratedFPGA', 'HardwareAcceleratedGPU', 'MemoryOptimized' and 'None'. Defaults to 'None'"
  type        = string
  default     = "None"
  validation {
    condition     = contains(["HardwareAcceleratedFPGA", "HardwareAcceleratedGPU", "MemoryOptimized", "None"], var.node_size_family)
    error_message = format("'node_size_family' type '%s' is not supported. Possible values are 'HardwareAcceleratedFPGA', 'HardwareAcceleratedGPU', 'MemoryOptimized' and 'None'")
  }
}

variable "node_size" {
  description = "The node size for a Spark pool. Possible values are 'Small', 'Medium', 'Large', 'None', 'XLarge', 'XXLarge' and 'XXXLarge'. Defaults to None"
  type        = string
  default     = "None"
  validation {
    condition     = contains(["Small", "Medium", "Large", "None", "XLarge", "XXLarge", "XXXLarge"], var.node_size)
    error_message = format("'node_size' type '%s' is not supported. Possible values are 'Small', 'Medium', 'Large', 'None', 'XLarge', 'XXLarge' and 'XXXLarge'")
  }
}

variable "node_count" {
  description = "The node count for a Spark pool."
  type        = number
  default     = null
}

variable "auto_pause_delay_in_minutes" {
  description = "The auto pause delay in minutes for a Spark pool."
  type        = number
  default     = 5
}

variable "auto_scale_max_node_count" {
  description = "The maximum node count for auto scaling a Spark pool."
  type        = number
  default     = null
}

variable "auto_scale_min_node_count" {
  description = "The minimum node count for auto scaling a Spark pool."
  type        = number
  default     = null
}

variable "cache_size" {
  description = "The cache size for a Spark pool."
  type        = number
  default     = null
}

variable "compute_isolation_enabled" {
  description = "Flag indicating if compute isolation is enabled for a Spark pool."
  type        = bool
  default     = false
}

variable "dynamic_executor_allocation_enabled" {
  description = "Flag indicating if dynamic executor allocation is enabled for a Spark pool."
  type        = bool
  default     = true
}

variable "min_executors" {
  description = "The minimum number of executors for a Spark pool."
  type        = number
  default     = 1
}

variable "max_executors" {
  description = "The maximum number of executors for a Spark pool."
  type        = number
  default     = 2
}

variable "library_requirement_content" {
  description = "The content of the library requirement for a Spark pool."
  type        = string
  default     = null
}

variable "library_requirement_filename" {
  description = "The filename of the library requirement for a Spark pool."
  type        = string
  default     = null
}

variable "session_level_packages_enabled" {
  description = "Flag indicating if session level packages are enabled for a Spark pool."
  type        = bool
  default     = false
}

variable "spark_config_content" {
  description = "The content of the Spark configuration for a Spark pool."
  type        = string
  default     = null
}

variable "spark_config_filename" {
  description = "The filename of the Spark configuration for a Spark pool."
  type        = string
  default     = null
}

variable "spark_log_folder" {
  description = "The Spark log folder for a Spark pool."
  type        = string
  default     = null
}

variable "spark_events_folder" {
  description = "The Spark events folder for a Spark pool."
  type        = string
  default     = null
}

variable "spark_version" {
  description = "The Spark version for a Spark pool."
  type        = string
  default     = null
}

variable "diagnostic_setting_log_categories" {
  description = "The diagnostic log categories to collect"
  type        = list(string)
  default     = ["BigDataPoolAppsEnded"]
}

variable "tags" {
  description = "The tags for a Spark pool."
  type        = map(string)
  default     = null
}
