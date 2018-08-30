# Nutanix Calm & Obtaining Info from External API

This Nutanix Calm blueprint will deploy a single VM and obtain information from an external API during deployment.

The intention of this blueprint is to allow quick demonstration of how eScript can be used to get information from an external/third-party API and apply that information during deployment.  For the purposes of this demo, the Prism Central v3 API has been used as the information source, although production versions of this script would use the relevant API for the service being accessed.

## Important Note

Ths blueprint should only be used in conjunction with the documentation provided by the Nutanix SE team.  Please contact your local rep for information on how to obtain this document.

## Components

- 1x CentOS 7 VM

## Prerequisites

To deploy this blueprint you will need the following things available.

- A CentOS 7 Linux VM image, published via the Nutanix Image Service

## Usage

- Import the blueprint into your Nutanix Calm environment
- Adjust credentials to suit your requirements (the import will warn about blueprint validation errors, since credentials are not saved in exported blueprints)
- Alter the blueprint service so that it deploys your CentOS 7 image
- Alter the new blueprint service so that it connects to your network
- Deploy the blueprint and pay special attention to the 3 required variables (Prism Central IP address, username and password)

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***