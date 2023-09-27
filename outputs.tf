output "workspace_id" {
  value = azurerm_synapse_workspace.this.id
}

output "workspace_name" {
  value = azurerm_synapse_workspace.this.name
}

output "workspace_resource_group_name" {
  value = azurerm_synapse_workspace.this.resource_group_name
}

output "workspace_managed_identity" {
  value = azurerm_synapse_workspace.this.identity[0].principal_id
}
