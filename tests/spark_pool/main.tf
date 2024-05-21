module "spark_pool" {
  source = "./modules/spark_pool"

  name                       = run.setup_tests.spark_pool_name
  workspace_id               = azurerm_synapse_workspace.this.id
  log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
}
