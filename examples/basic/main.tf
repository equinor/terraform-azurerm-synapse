provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "random_id" "this" {
  byte_length = 8
}

resource "random_password" "this" {
  length = 12
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${random_id.this.hex}"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_storage_account" "dls" {
  name                     = "dls${random_id.this.hex}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  is_hns_enabled           = true
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_account" "staud" {
  name                     = "staud${random_id.this.hex}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

module "synapse" {
  source = "../.."

  workspace_name                   = "syn-${random_id.this.hex}"
  resource_group_name              = azurerm_resource_group.this.name
  location                         = azurerm_resource_group.this.location
  data_lake_gen2_id                = azurerm_storage_account.dls.id
  audit_storage_account_id         = azurerm_storage_account.staud.id
  log_analytics_workspace_id       = azurerm_log_analytics_workspace.this.id
  sql_administrator_login          = "SynapseSQLAdmin"
  sql_administrator_login_password = random_password.this.result
}
