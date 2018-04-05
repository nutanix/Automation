# Nutanix Setup Scripts

- **Authors:**      C. Rasmussen (crasmussen@nutanix.com)

- **Date:**         May 23, 2017

(1) INTRODUCTION
----------------

This script is intended to be a one-step cluster creation process for Nutanix clusters.  It will (by default):

- Create a Nutanix cluster called 'NTNX-Demo'
- Configure DNS servers
- Configure NTP servers
- Set the cluster name
- Set the cluster timezone
- Set the cluster external IP address
- Set the cluster data services IP address
- Rename the default container to 'NTNX-Container'
- Rename the default storage pool to "sp1"
- Add an "Images" container
- Configure a default "vlan.0" network
- Create a CentOS7 image
- Create a CentOS7 VM

The above tools are recommended for use during Nutanix Tech Summit events.

(2) REQUIRED SOFTWARE
---------------------
- Bash v3.2 (interpreters are available for windows, see https://www.cygwin.com/)

(3) ASSUMPTIONS (!)
-------------------
- Nodes are built with Acropolis 5.1
- Hypervisor is AHV
- Internet connection is available (e.g. for downloading CentOS7 ISO and default NTP server)

(4) PACKAGE FILES
------------------
The following files are included in this package.

- setup-cluster.sh             -- Main setup script

(5) INSTALLATION (Linux, Mac)
-----------------------------
**File:**
- file: setup-cluster.sh 

**Execution(OS X):**
1. chmod +x setup-cluster.sh
2. ./setup-cluster.sh

(6) ONE-LINE INSTALL
--------------------

Assumes the included settings (see above) are OK for your environment - this is unlikely to work!  Be warned!  :)

**Execution(OS X/Linux):**
1.  sh -c "$(curl -fsSL https://raw.githubusercontent.com/digitalformula/nutanix-scripts/master/setup-cluster.sh)"

(7) LICENSE (LPPL):
-------------------
This program is free software; Project Public License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
