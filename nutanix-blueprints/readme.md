# Nutanix Calm Blueprints

This repository contains a selection of sample blueprints for use with Nutanix Calm.

## Compatibility

Unless otherwise specified, these blueprints have been created for use with CentOS 7 Linux VMs.  There may be changes required before they can be used with other Linux distributions.

## Prerequisites

For all blueprints contained in this repository, an Internet connection is required from the Nutanix cluster.

VMs in these blueprints make extensive use of package installation from public repositories, e.g. for CentOS 7.

## Usage

See the readme.md usage notes for each application.

## Note re credentials

Some of the downloadable blueprints use SSH public/private key authentication instead of username/password authentication.  Please ensure you have configured your public/private keys before deploying SSH-authenticated blueprints.

A quick guide for generating SSH keys is available here: https://portal.nutanix.com/#/page/docs/details?targetId=Nutanix-Calm-Admin-Operations-Guide-v10:nuc-generating-private-key-t.html

## Support

These blueprints are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these blueprints may deploy applications that do not follow best practices.  Please check through each blueprint to ensure the configuration suits your requirements.

***Changes will be required before these application blueprints can be used in production environments.***