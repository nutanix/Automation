# Oracle - Single Instance

This Nutanix Calm blueprint will deploy Oracle 12 on Oracle Linux 7.

The intention of this blueprint is to show how Nutanix Calm be used to deploy a single instance Oracle database with minimal effort and little to no Oracle-specific knowledge.

While this blueprint must not replace industry best practices with regards to Oracle database design, it can be used as a basis for Oracle deployments from Nutanix Calm.

## Components

- 1x Oracle Linux 7 VM
- 1x qcow2 disk image containing Oracle installation files ( *do not distribute these* )

## Prerequisites

To deploy this blueprint you will need the following things available.

- This blueprint only.  All settings are contained within the blueprint itself.

## Usage

- Import the blueprint into your Nutanix Calm environment
- Adjust credentials to suit your requirements (the import will warn about blueprint validation errors, since credentials are not saved in exported blueprints)
- Alter all Calm variables to suit your requirements
- Alter the Oracle Linux Calm service/VM so that it connects to your preferred network
- Launch the blueprint
- Fill in all required runtime variables, paying particular attention to the credentials section

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***