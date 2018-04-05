# Synopsis

This small web application is intended to demonstrate high-level use of the Nutanix REST API.

Specifically, it will show the following:

- A basic 'GET' request that will show cluster configuration details
- A basic 'POST' request to create a Nutanix Acropolis container
- An intermediate 'POST' request to create an empty/shell VM based on a selected server profile
- An advanced 'POST' request using Cloud-Init and SaltStack, to deploy a functioning Apache web server

# Motivation

The Nutanix REST API has the ability to completely control your Nutanix AHV cluster in the way that suits your requirements.

This set of demos came about because I wanted to show the various stages of using the Nutanix REST API - basic data collection through to complete VM/self-service portal deployment.

# Contributors

Chris Rasmussen, Senior Systems Engineer, Nutanix Melbourne, AU

# Code Example

Use of the application's local API model could be as follows.

```
$client = new \DigitalFormula\ApiRequest\ApiRequest(
   $_POST[ 'cluster-username' ],
   $_POST[ 'cluster-password' ],
   $_POST[ 'cvm-address' ],
   $_POST[ 'cluster-port' ],
   $_POST[ 'cluster-timeout' ]
);

/* get the response data in JSON format */
$clusterInfo = $client->get( '/PrismGateway/services/rest/v1/cluster/' )->json();
```

From there, it's a case of parsing the JSON output using your favourite method, and displaying the results as you see fit.

# Installation

## Downloading from source

Once downloaded, you will need to make sure your laptop/workstation has [PHP Composer](http://getcomposer.org/) available.  This is a requirement for running this demo from a local web server.

- From the project's root directory run the following command.  This will satisfy all prerequisites via the PHP Composer dependency manager.

```composer install```

## Prerequisites - Local web server

- PHP >= 5.4 (required for local web server support)
- PHP with cURL support (required so the demo can read from a remote device)

## Prerequisites - Nutanix demo VM

- VirtualBox
- The demo VM
- The demo VM with a single NAT adapter and a single bridged adapter (wireless or Ethernet) - NAT adapter required for connection over host VPN

Note: The demo VM already has a 'nutanix' user.  The password is currently configured to be the Nutanix cluster default password.

## Prerequisites - All environments

- A connection to a Nutanix cluster running NOS >= 4.1
- Credentials for the relevant Nutanix cluster (read-only is fine, unless you want to make cluster changes)
- A recent web browser

## Preparation - Cloud-Init Apache web server deployment

### Cloud-Init configuration script

Save the following code snippet somewhere on your local system, as web-server.yaml:

```#cloud-config
   users:
     - name: nutanix
       sudo: ['ALL=(ALL) NOPASSWD:ALL']
       lock-passwd: false
       passwd: $6$qxg9VycBEn76FVjP$mVdBH3ohk0FZEpiyooDa84PqYnknWqEOu50vh27iPi9kHUgiFmaWZAUIQFn8E3y2/p8m9GexK7WUyVLnfGmvp/

   packages:
     - httpd
   package_upgrade: true
   hostname: centos-web-auto
   runcmd:
     - systemctl enable httpd.service
     - systemctl start httpd.service
     - systemctl stop firewalld
     - systemctl disable firewalld
```

Note: There is also a copy of web-server.yaml in the /cloud-init folder within this project.

### AHV host cluster

The following requirements must be met before the Apache web server deployment will run successfully

- Your AHV cluster must host a Linux-based Acropolis Image or Linux-based VM that has the Cloud-Init package installed
- web-server.yaml must exist on one of your cluster's containers (copy it there using NFS mount on OS X or WinSCP on Windows)

## How to run - Demo VM

- Start the VM
- Make sure the VM has an IP address
- Browse to the VM's IP address (the demo should already be in the root of the web server)

## How to run - Local web server

- From a terminal, change to the demo's root directory
- If using OS X, run 'php -S localhost:8000' (change the web server's port, if required)
- Browse to http://localhost:<port>/ e.g. https://localhost:8000 from the example above

# Updates

2018.04.06

- moved to /nutanix/automation from https://github.com/digitalformula/nutanix-graphical-api-demo (JonKohler
)
2016.06.28

- Added "DEMO-<date>-" prefix to all created objects (containers, VMs)

2016.06.20

- Added RAW JSON dump to list of available demos

2016.06.19

- Changed from application-level API request library to Packagist-hosted \DigitalFormula\ApiRequest\ApiRequest
- Changed from application-level formatting library to Packagist-hosted \DigitalFormula\Formatting\Text
- Added additional 120GB SCSI disk to customised VM deployment (just to show how it is done)

2016.06.14

- Added large section for query cluster in preparation for Cloud-Init VM deployment
- Added clickable links for quick population of required fields during Cloud-Init VM deployment

2016.06.13

- Completely redesigned the main demo page
- Added 'gulp' build scripts & changed from css to scss
- Implemented session cookies/header authorization
- Cleaned up script.js
- Split some output markup into /output-templates/ files
- Removed FontAwesome (Bootstrap glyphicons good enough for this small demo)

2016.06.09

- Add deployment of complete VM from clone w/ Cloud-Init & SaltStack
- Improvements in API call methods (single client instance per action)
- Much improved call methods (direct GET/POST instead of lengthy doAPIRequest method, now removed)

2016.06.05

- Cleaned up code
- Removed Nutanix Bootstrap, for now - will be added again later
- Removed graph-based storage numbers (problematic on many environments)

2015.09.02

- Integrated Nutanix Bootstrap (much improved UI & fonts)

2015.06.03

- Added numCoresPerVcpu to all server profiles

2015.06.02

- Created a common credential and CVM/cluster details form above the demos
- Added the ability to create a VM through the API ... KVM/AHV required!
- Changed entire demo so it works with relative directories

2015.05.21

- Cleaned up API request method slightly
- Added capability for API request method to process both GET and POST requests
- Removed hard-coded default username & password (user is now required to enter both)

2015.05.20

- Added ability to create a container

2015.05.01

- Container info added
- A bit of code cleanup, mostly in script.js for JSON response processing

2015.04.30

- Text storage removed
- Graphs added to show SSD and HDD tier usage vs capacity
- More of a 'dashboard' look, with high-level configuration info in the top panel

# Acropolis version testing

This demo has been tested using Acropolis Base versions from 4.1 to 4.6.1.1 (including Nutanix Community Edition).