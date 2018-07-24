# Nutanix Calm & Assigning IP Address via eScript

This Nutanix Calm blueprint will deploy a single VM and assign an IP address to that VM via eScript.

The intention of this blueprint is to allow quick demonstration of how eScript can be used to get an IP address from an external source and assign that IP address to a VM during creation.

## Important Note

Ths blueprint should only be used in conjunction with the documentation provided by the Nutanix SE team.  Please contact your local rep for information on how to obtain this document.

## Components

- 1x CentOS 7 VM

## Important Note

1x additional Calm License is consumed during this style of deployment.  This is due to the way Calm assigns licenses using the "Existing Machine" construct.

## Prerequisites

To deploy this blueprint you will need the following things available.

- A CentOS 7 Linux VM image, published via the Nutanix Image Service
- An IP address that can be statically assigned to your new VM
- A "Jump Host" i.e. VM that can be used as the target for running eScripts.  Note that no changes are made to this jump host during any part of this deployment.

## Usage

- Import the blueprint into your Nutanix Calm environment
- Adjust credentials to suit your requirements (the import will warn about blueprint validation errors, since credentials are not saved in exported blueprints)
- Alter the new blueprint service so that it deploys your CentOS 7 image
- Alter the new blueprint service so that it connects to your network
- Alter the existing machine service so that it uses the IP address of a machine in your environment
- Edit the scripts so that they assign an IP address relevant to your environment

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***