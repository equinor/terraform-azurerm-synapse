mock_provider "azurerm" {
    override_data {
      target = data.azurerm_storage_account.audit_storage
      values = {
          id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Storage/storageAccounts/staudit"
          primary_blob_endpoint = "https://staudit.blob.core.windows.net/"
      }
    }
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run simple_workspace {
  command = plan



  variables {
    workspace_name             = run.setup_tests.workspace_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    data_lake_gen2_id          = run.setup_tests.data_lake_gen2_id
    audit_storage_account_id   = run.setup_tests.audit_storage_account_id
  }

  assert {
    condition     = output.workspace_name == run.setup_tests.workspace_name
    error_message = "Invalid name for workspace"
  }

}