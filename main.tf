resource "azurerm_synapse_workspace" "this" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_data_lake_gen2_filesystem_id = var.data_lake_gen2_filesystem_id == null ? azurerm_storage_data_lake_gen2_filesystem.this[0].id : var.data_lake_gen2_filesystem_id
  sql_identity_control_enabled         = var.sql_identity_control_enabled
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = var.sql_administrator_login_password
  dynamic "sql_aad_admin" {
    for_each = { for sql_aad_admin in var.sql_aad_admins : sql_aad_admin.login => sql_aad_admin }

    content {
      login     = sql_aad_admin.value.login
      object_id = sql_aad_admin.value.object_id
      tenant_id = sql_aad_admin.value.tenant_id
    }
  }
  dynamic "aad_admin" {
    for_each = { for aad_admin in var.aad_admins : aad_admin.login => aad_admin }

    content {
      login     = aad_admin.value.login
      object_id = aad_admin.value.object_id
      tenant_id = aad_admin.value.tenant_id
    }
  }

  dynamic "identity" {
    for_each = coalesce([var.identity])

    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", [])
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key == null ? [] : [var.customer_managed_key]
    content {
      key_versionless_id = customer_managed_key.value.key_versionless_id
      key_name           = lookup(customer_managed_key.value, "key_name", "cmk")
    }
  }
  dynamic "azure_devops_repo" {
    for_each = var.github_repo == null ? (var.azure_devops_repo == null ? [] : [var.azure_devops_repo]) : [] # If a Github repo is given do not use devops repo
    content {
      account_name    = azure_devops_repo.value.account_name
      branch_name     = azure_devops_repo.value.branch_name
      last_commit_id  = lookup(azure_devops_repo.value, "last_commit_id", null)
      project_name    = azure_devops_repo.value.project_name
      repository_name = azure_devops_repo.value.repository_name
      root_folder     = lookup(azure_devops_repo.value, "root_folder", "/")
      tenant_id       = lookup(azure_devops_repo.value, "tenant_id", null)
    }
  }
  dynamic "github_repo" {
    for_each = var.github_repo == null ? [] : [var.github_repo]
    content {
      account_name    = github_repo.value.account_name
      branch_name     = github_repo.value.branch_name
      last_commit_id  = lookup(github_repo.value, "last_commit_id", null)
      repository_name = github_repo.value.repository_name
      root_folder     = lookup(github_repo.value, "root_folder", "/")
      git_url         = lookup(github_repo.value, "git_url", null)
    }
  }
  data_exfiltration_protection_enabled = var.data_exfiltration_protection_enabled
  linking_allowed_for_aad_tenant_ids   = var.allowed_linked_tenant_ids
  managed_resource_group_name          = var.managed_resource_group_name
  managed_virtual_network_enabled      = var.managed_virtual_network_enabled
  compute_subnet_id                    = var.compute_subnet_id
  public_network_access_enabled        = var.public_network_access_enabled
  purview_id                           = var.purview_id

  tags = var.tags
}

module "workspace_storage" {
  source = "./modules/storage"

  count = var.data_lake_gen2_filesystem_id == null ? 1 : 0

  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_name              = var.datalake_account_name
  shared_access_key_enabled = true
  is_hns_enabled            = true
  blob_properties = {
    versioning_enabled  = false
    restore_policy_days = 0
    change_feed_enabled = false
  }
  network_rules_default_action = "Allow"
  log_analytics_workspace_id   = var.log_analytics_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  count = var.data_lake_gen2_filesystem_id == null ? 1 : 0

  name               = var.workspace_name
  storage_account_id = module.workspace_storage[0].account_id
}

resource "azurerm_synapse_firewall_rule" "this" {
  for_each = { for fr in var.firewall_rules : fr.name => fr }

  synapse_workspace_id = azurerm_synapse_workspace.this.id
  name                 = each.value.name
  start_ip_address     = each.value.start_ip_address
  end_ip_address       = each.value.end_ip_address
}

resource "azurerm_synapse_integration_runtime_azure" "this" {
  for_each = { for ir in var.integration_runtimes : ir.name => ir }

  name                 = each.value.name
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  location             = each.value.location ? each.value.location : azurerm_synapse_workspace.this.location
  compute_type         = each.value.compute_type
  core_count           = each.value.core_count
  description          = each.value.description
  time_to_live_min     = each.value.time_to_live_min
}

resource "azurerm_synapse_integration_runtime_self_hosted" "this" {
  for_each = { for shir in var.self_hosted_integration_runtimes : shir.name => shir }

  name                 = each.value.name
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  description          = each.value.description
}

resource "azurerm_synapse_linked_service" "this" {
  for_each = { for ls in var.linked_services : ls.name => ls }

  name                  = each.value.name
  synapse_workspace_id  = azurerm_synapse_workspace.this.id
  type                  = each.value.type
  type_properties_json  = each.value.type_properties_json
  additional_properties = each.value.additional_properties
  annotations           = each.value.annotations
  description           = each.value.description
  dynamic "integration_runtime" {
    for_each = coalesce(each.value.integration_runtime)
    content {
      name       = integration_runtime.value.name
      parameters = integration_runtime.value.parameters
    }
  }
  parameters = each.value.parameters
}

resource "azurerm_synapse_managed_private_endpoint" "this" {
  for_each = { for mpe in var.managed_private_endpoints : mpe.name => mpe }

  name                 = each.value.name
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  target_resource_id   = each.value.target_resource_id
  subresource_name     = each.value.subresource_name
}

resource "azurerm_synapse_private_link_hub" "this" {
  count               = var.create_private_link_hub ? 1 : 0
  name                = "plh-${azurerm_synapse_workspace.this.name}"
  resource_group_name = azurerm_synapse_workspace.this.resource_group_name
  location            = azurerm_synapse_workspace.this.location

  tags = var.private_link_hub_tags
}
