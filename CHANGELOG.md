# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [v1.1.4] - 2018-10-03

### Added

- Added feature to allow users specify if storage_encryption should be enabled for the blueprism db and if so the kms_key_id to be associated with it.
- Added feature to allow users to specify a snapshot_identifier to allow restoring db from a snapshot.

## [v1.1.3] - 2018-07-09

### Added

- Updated resource template to automatically start resource listener when someone logs into administrator user on resource pc.

### Fixed

- Fixed typo in client_setup and resource_setup template for adding correct blueprism path to env path variable. 

## [v1.1.2] - 2018-06-21

### Added

- Added self to the data filter for owner along with amazon being the owner to allow users to use custom image they may have created. 

## [v1.1.1] - 2018-06-18

### Removed

- Removed the provider block from the module to avoid conflicts and allow users to use this module with provider profiles in order to specify different regions. 

## [v1.1] - 2018-06-15

### Added

- Allow provisioning appserver, interactive client and resource pc with different aws amis if provided as a variable to the module, else will take the default value of Windows Server 2016 English.
- Allow passing info for multiple username with passwords that should be created separately on appserver, client and resource pc while initializing them.
- Allow users to pass list of custom powershell commands that they would like to run while creating a new blueprism appserver, client or resource machine.
- New feature to install Blue Prism MAPI Ex to the resource pc if the installer path is specified.

## [v1.0.0] - 2018-06-14

### Added

- Everything! Initial release of the module.
- Releasing for open source.
