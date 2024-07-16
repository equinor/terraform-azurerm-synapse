variable "spark_pool_name" {
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
