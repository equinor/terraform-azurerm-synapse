variable "workspace_name" {
  description = "The name of the synape workspace."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "log_analytics_id" {
  description = "Id of the log analytics workspace to send logs to."
  type        = string
}

variable "log_analytics_destination_type" {
  description = "Type of destination in log analytics."
  type        = string
  default     = "Dedicated"
}

variable "identity" {
  description = "The identity or identities to configure for this Workspace."

  type = object({
    type         = optional(string, "SystemAssigned")
    identity_ids = optional(list(string), [])
  })

  default = {}
}

variable "data_lake_gen2_filesystem_id" {
  description = "The resource id of a Azure DataLake gen2 filesystem resource. If this is not provided datalake name must be provided"
  type        = string
  default     = null
}
variable "datalake_account_name" {
  description = "The name of the data lake storage account. Will not be used if data_lake_gen2_id is provided"
  type        = string
  default     = null
}

variable "sql_identity_control_enabled" {
  description = "Are pipelines (running as workspace's system assigned identity) allowed to access SQL pools?"
  type        = bool
  default     = true
}

variable "sql_aad_admins" {
  description = "The SQL AAD admins of this workspace"
  type = set(object({
    login     = string
    object_id = string
    tenant_id = string
  }))

  default = []
}

variable "sql_administrator_login" {
  description = "The username of the SQL Administrator. If not given either aad_admin or customer_managed_key must be given instead"
  type        = string

  default = "sqladminuser"
}

variable "sql_administrator_login_password" {
  description = "The password of the SQL Administrator. If not given either aad_admin or customer_managed_key must be given instead"
  type        = string

  default = null
}

variable "aad_admins" {
  description = "The AAD admins of this workspace. Conflicts with customer_managed_key"
  type = list(object({
    login     = string
    object_id = string
    tenant_id = string
  }))

  default = null
}

variable "customer_managed_key" {
  description = "A customer managed key used for double encryption of the workspace."
  type = object({
    key_versionless_id = string
    key_name           = optional(string, "cmk")
  })

  default = null
}

variable "azure_devops_repo" {
  description = "Configuration for connecting the workspace to a Azure devops repo. If a github repo is specified, that will be used instead."
  type = object({
    account_name    = string
    branch_name     = string
    last_commit_id  = optional(string, null)
    project_name    = string
    repository_name = string
    root_folder     = optional(string, "/")
    tenant_id       = optional(string, null)
  })

  default = null
}

variable "github_repo" {
  description = "Configuration for connecting the workspace to a GitHub repo."
  type = object({
    account_name    = string
    branch_name     = string
    last_commit_id  = optional(string, null)
    repository_name = string
    root_folder     = optional(string, "/")
    git_url         = optional(string, null)
  })

  default = null
}

variable "data_exfiltration_protection_enabled" {
  description = "Enable data exfiltration protection. Defaults to true. Requires that managed_virtual_network_enabled is set to true"
  type        = bool

  default = true
}

variable "allowed_linked_tenant_ids" {
  description = "Allowed AAD Tenant Ids For Linking."
  type        = list(string)

  default = null
}

variable "managed_resource_group_name" {
  description = "Name of the managed resourcegroup."
  type        = string

  default = null
}

variable "managed_virtual_network_enabled" {
  description = "Enable a managed internal network in synapse. Defaults to true"
  type        = bool

  default = true
}

variable "compute_subnet_id" {
  description = "Id of the subnets the computes will connect to."
  type        = string

  default = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the workspace. Defaults to false"
  type        = bool

  default = false
}

variable "purview_id" {
  description = "Id of purview account to connecto to this workspace."
  type        = string

  default = null
}

variable "allowed_firewall_rules" {
  description = "List  of rules allowing certain ips through the firewall."
  type = list(object({
    name : string
    start_ip_address : string
    end_ip_address : string
  }))

  default = null
}

variable "linked_services" {
  description = "List over linked services."
  type = list(object({
    name : string
    type : string
    type_properties_json : string
    additional_properties : optional(map(string), null)
    annotations : optional(list(map(string)), null)
    description : optional(string, "")
    integration_runtime = optional(object({
      name : optional(string, null)
      parameters : optional(map(string), null)
    }))
    parameters : optional(map(string), null)
  }))
  default = []
}

variable "managed_private_endpoints" {
  description = "List over managed private endpoints."
  type = list(object({
    name : string
    target_resource_id : string
    subresource_name : string
  }))
  default = []
}

variable "create_private_link_hub" {
  description = "Should there be created a synapse private link hub?"
  type        = bool
  default     = false
}

variable "private_link_hub_tags" {
  description = "Tags for the private link hub."
  type        = map(string)
  default     = null
}

variable "firewall_rules" {
  description = "List of firewall rules."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))

  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)

  default = {}
}
