terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

resource "random_string" "name_suffix" {
  length  = 5
  numeric = false
  upper   = false
  special = false
  lower   = true
}

resource "random_uuid" "subscription_id" {}

locals {
  name_suffix         = random_string.name_suffix.result
  resource_group_name = "rg-${local.name_suffix}"
}
