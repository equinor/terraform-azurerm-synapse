# Terraform module for Azure Synapse

[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-synapse)](https://github.com/equinor/terraform-azurerm-synapse/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-synapse)](https://github.com/equinor/terraform-azurerm-synapse/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-synapse/badge)](https://developer.equinor.com/governance/scm-policy/)

Terraform module which creates Azure Synapse resources.

## Features

TODO(@ErlendT): add list of features.

## Prerequisites

- Azure role `Contributor` at the resource group scope.
- Azure role `Log Analytics Contributor` at the Log Analytics workspace scope.

## Usage

```terraform
provider "azurerm" {
  features {}
}

module "synapse" {
  source  = "equinor/synapse/azurerm"
  version = "~> 5.0"

  workspace_name                   = "example-synapse"
  resource_group_name              = azurerm_resource_group.example.name
  location                         = azurerm_resource_group.example.location
  data_lake_gen2_id                = azurerm_storage_account.data_lake.id
  audit_storage_account_id         = azurerm_storage_account.audit.id
  log_analytics_workspace_id       = module.log_analytics.workspace_id
  sql_administrator_login          = "SynapseSQLAdmin"
  sql_administrator_login_password = random_password.example.result
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

resource "azurerm_storage_account" "data_lake" {
  name                     = "datalake"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  is_hns_enabled           = true
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_account" "audit" {
  name                     = "auditstorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.4"

  workspace_name           = "example-workspace"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
}

resource "random_password" "example" {
  length = 12
}
```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
