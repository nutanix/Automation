# Nutanix Calm & SaltStack

These Nutanix Calm blueprints will deploy a simple SaltStack configuration management environment.

## Components

- 1x SaltStack Master
- 1x VM that acts as a SaltStack Minion (managed by the SaltStack Master)

## Prerequisites

To deploy these blueprints you will need the following things available.

- A CentOS 7 Linux VM image, published via the Nutanix Image Service
- Public and private key for your environment (see [Generating SSH Key](https://portal.nutanix.com/#/page/docs/details?targetId=Nutanix-Calm-Admin-Operations-Guide-v10:nuc-generating-private-key-t.html) in the Nutanix documentation)

## Usage

- Import the blueprints into your Nutanix Calm environment
- Adjust credentials to suit your requirements (the import will warn about blueprint validation errors, since credentials are not saved in exported blueprints)
- Alter each Calm service/VM so that it deploys your CentOS 7 image
- Alter each Calm service/VM so that it connects to your preferred network
- Launch the SaltStack Master blueprint
- Fill in all required runtime variables
- Launch the SaltStack Minion blueprint
- Fill in all required variables, especially the IP address for your SaltStack Master
- After deployment, run the custom action 'ApplyDesiredState' on the SaltStack Minion
- Check the Calm action output screens to see that all latest packages have been installed 

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***