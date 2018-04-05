# Nutanix Calm & PHP Composer

This Nutanix Calm blueprint will deploy PHP Composer on an existing CentOS 7 VM.

## Prerequisites

To deploy this blueprint you will need the following things available.

- An existing CentOS 7 Linux VM with PHP *already installed* (the script will verify this)
- An existing CentOS 7 Linux VM with wget *already installed* (the script will verify this)
- An Internet connection from the CentOS 7 Linux VM
- SSH private key for your VM (the blueprint is configured to use SSH key authentication)

## Usage

- Import the blueprint into your Nutanix Calm environment
- Adjust credentials to suit your requirements (the import will warn about blueprint validation errors, since credentials are not saved in exported blueprints)
- Launch the blueprint
- Fill in all required runtime variables, paying particular attention to the existing VM IP address
- After deployment, SSH to the VM and run `composer`

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***