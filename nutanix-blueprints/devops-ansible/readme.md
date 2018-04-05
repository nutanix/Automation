# Nutanix Calm & Ansible

These Nutanix Calm blueprints will deploy a simple Ansible configuration management environment.

## Components

- 1x Ansible Controller
- 1x VM that acts as an Ansible node (managed by the Ansible Controller)

## Prerequisites

To deploy these blueprints you will need the following things available.

- A CentOS 7 Linux VM image, published via the Nutanix Image Service
- Public and private key for your environment (see [Generating SSH Key](https://portal.nutanix.com/#/page/docs/details?targetId=Nutanix-Calm-Admin-Operations-Guide-v10:nuc-generating-private-key-t.html) in the Nutanix documentation)

## Usage

- Import the blueprints into your Nutanix Calm environment
- Adjust credentials to suit your requirements (the import will warn about blueprint validation errors, since credentials are not saved in exported blueprints)
- Alter each Calm service/VM so that it deploys your CentOS 7 image
- Alter each Calm service/VM so that it connects to your preferred network
- Launch the Ansible controller blueprint
- Fill in all required runtime variables
- Launch the Ansible node blueprint
- Fill in all required variables, especially the IP address for your Ansible controller
- After deployment, run the custom action 'ApplyApacheConfiguration' on the Ansible controller
- Browse to the Ansible node's IP address to see Apache has been installed and enabled

## Important Security Note

*This blueprint disables the `host_key_checking` setting within `/etc/ansible/ansible.cfg`.  This is for ease-of-use during demos, only!  Don't do this in production!*  

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***