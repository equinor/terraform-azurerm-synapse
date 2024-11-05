# Changelog

## [5.0.0](https://github.com/equinor/terraform-azurerm-synapse/compare/v4.0.0...v5.0.0) (2024-11-05)


### ⚠ BREAKING CHANGES

* remove variable `spark_pools`. To migrate your project, migrate `azurerm_synapse_spark_pool` resources created by this module into the `spark_pool` submodule instead.

### Code Refactoring

* add submodule `spark_pool` ([#25](https://github.com/equinor/terraform-azurerm-synapse/issues/25)) ([c0cf7e5](https://github.com/equinor/terraform-azurerm-synapse/commit/c0cf7e577c77aaf2850f377e7f9bf33aa2a3bb34))

## [4.0.0](https://github.com/equinor/terraform-azurerm-synapse/compare/v3.0.1...v4.0.0) (2024-04-05)


### ⚠ BREAKING CHANGES

* **diagnostics:** removed diagnostic setting retention policy ([#23](https://github.com/equinor/terraform-azurerm-synapse/issues/23))

### Features

* **diagnostics:** removed diagnostic setting retention policy ([#23](https://github.com/equinor/terraform-azurerm-synapse/issues/23)) ([41e36e5](https://github.com/equinor/terraform-azurerm-synapse/commit/41e36e50a889fffca6e5f7695e6654e64fe57922))
* upgrade azurerm_storage_account properties ([#20](https://github.com/equinor/terraform-azurerm-synapse/issues/20)) ([ad6157d](https://github.com/equinor/terraform-azurerm-synapse/commit/ad6157dbe65c06b53b42df5530d69033d402e28a))

## [3.0.1](https://github.com/equinor/terraform-azurerm-synapse/compare/v3.0.0...v3.0.1) (2024-01-26)


### Bug Fixes

* Add lifecycle ignore to node-count for sparkpools to avoid wrong updates ([#12](https://github.com/equinor/terraform-azurerm-synapse/issues/12)) ([b5ffe83](https://github.com/equinor/terraform-azurerm-synapse/commit/b5ffe836df9c1b3747d24ab5ae14e8e109d08bf8))

## [3.0.0](https://github.com/equinor/terraform-azurerm-synapse/compare/v2.0.0...v3.0.0) (2024-01-23)


### ⚠ BREAKING CHANGES

* Add ad authentication only option ([#13](https://github.com/equinor/terraform-azurerm-synapse/issues/13))

### Features

* Add ad authentication only option ([#13](https://github.com/equinor/terraform-azurerm-synapse/issues/13)) ([5df0df3](https://github.com/equinor/terraform-azurerm-synapse/commit/5df0df3fa47c88c3cdaa0b373ced08953cbe0b62))

## [2.0.0](https://github.com/equinor/terraform-azurerm-synapse/compare/v1.0.0...v2.0.0) (2023-09-27)


### ⚠ BREAKING CHANGES

* Removed ability to create private link hub

### Code Refactoring

* Removed ability to create private link hub ([f98ded2](https://github.com/equinor/terraform-azurerm-synapse/commit/f98ded2a725f8812e4ea3ff584d67073e1fedaa0))

## [1.0.0](https://github.com/equinor/terraform-azurerm-synapse/compare/v0.1.0...v1.0.0) (2023-09-27)


### ⚠ BREAKING CHANGES

* Remove unused variable
* Removed log analytics destination type

### Bug Fixes

* Issues with spark pools auto scale ([e369d78](https://github.com/equinor/terraform-azurerm-synapse/commit/e369d784ecb717476c184e71b67157392da498dc))
* Remove unused variable ([d695f31](https://github.com/equinor/terraform-azurerm-synapse/commit/d695f31b6155147c4a4006a591d076b021aeef52))
* Removed log analytics destination type ([0b5dac0](https://github.com/equinor/terraform-azurerm-synapse/commit/0b5dac09a7984a2d6619e8c774ca84dca31c32e9))

## 0.1.0 (2023-05-24)


### ⚠ BREAKING CHANGES

* Wrong variable names
* Update variable name

### Bug Fixes

* Update audit permissions ([d8fc4fa](https://github.com/equinor/terraform-azurerm-synapse/commit/d8fc4fa09b4af5b9b83de06375f7766e9d0413ae))
* Wrong variable names ([d4fe73e](https://github.com/equinor/terraform-azurerm-synapse/commit/d4fe73e6b052dfdab2a3e928c5ff854bf3acec88))


### Miscellaneous Chores

* Update variable name ([96c5add](https://github.com/equinor/terraform-azurerm-synapse/commit/96c5adda99500c9fb9ac3b26aeec2e315906dc5a))
