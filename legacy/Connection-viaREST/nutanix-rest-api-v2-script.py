#!/usr/bin/env python
#
# Copyright (c) 2014 Nutanix Inc. All rights reserved.
#
# Nutanix REST API v2 
#
# This script uses Python 2.7.
# This script shows how to authenticate, create protection domains,
# and add unprotected VMs to a protection domain provided by the Prism Gateway.
# This script is ready to copy and paste for execution, but assign the
# variables within the script.
# WARNING: Be sure that when adding VMs to a protection domain, they are first
# unprotected.
# NOTE: You need a Python library called "requests" which is available from
# the url: http://docs.python-requests.org/en/latest/user/install/#install

import json
import os
import random
import requests
import sys
import unicodedata
import traceback
from requests.packages.urllib3.exceptions import InsecureRequestWarning

# This block initializes the parameters for the request.  


class test_rest_api():
    def __init__(self):

        # Initializes the options and the logfile from GFLAGS.
        self.ip_addr = "cluster_ip_address"
        self.username = "cluster_username"
        self.password = "cluster_password"
        # Base URL at which REST services are hosted in Prism Gateway.
        base_url = 'https://%s:9440/PrismGateway/services/rest/v2.0/'
        self.base_url = base_url % self.ip_addr
        self.session = self.get_server_session(self.username, self.password)

    def get_server_session(self, username, password):

        # Creating REST client session for server connection, after globally
        # setting authorization, content type, and character set.
        session = requests.Session()
        session.auth = (username, password)
        session.verify = False
        session.headers.update({'Content-Type': 'application/json; charset=utf-8'})
        return session

        # Prints the cluster information and loads JSON objects to be formatted.

    def get_cluster_information(self):

        cluster_url = self.base_url + "/cluster"
        print("Getting cluster information for cluster %s" % self.ip_addr)
        server_response = self.session.get(cluster_url)
        print("Response code: %s" % server_response.status_code)
        return server_response.status_code ,json.loads(server_response.text)

        # Creates a protection domain with assigned name.

    def create_protection_domain(self):

        protection_domain_url = self.base_url + "/protection_domains"
        print("Created a protection domain on cluster %s" % self.ip_addr)
        payload = {}
        # Designate a protection domain name.
        payload["value"] = "pd_name"
        payload_in_json = json.dumps(payload)
        server_response = self.session.post(protection_domain_url,
                                            data=payload_in_json)
        print ("Response code: %s" % server_response.status_code)
        return json.loads(server_response.text)

        # Get the list of unprotected VMs.

    def get_unprotected_vms(self):

        unprotected_vm_url = (self.base_url +
                              "/protection_domains/unprotected_vms/")
        print ("List of unprotected VMs in cluster %s" % self.ip_addr)
        server_response = self.session.get(unprotected_vm_url)
        print ("Response code: %s" % server_response.status_code)
        return json.loads(server_response.text)

        # Add the entire list of unprotected VMs to Protection Domain. This script will
        # exclude Controller VMs.
        # If you have VMs on Metro Availability protection domains then
        # the cluster will give you a warning,
        # ignore those VMs, and continue to add the other unprotected VMs.

    def add_vm_to_pd(self):

        # Designate the location of the protection domain for "pd_name".
        add_vm_pd_url = (self.base_url + "/protection_domains/pd_name/protect_vms")
        print ("Added unprotected VMs to a Protection Domain on cluster %s" % self.ip_addr)
        payload = {}
        vms = ntnx_test_rest_api.get_unprotected_vms()['entities']
        vm_names = []
        
        # Designate the name for the unprotected VM for "vm_name".
        for vm in vms:#To exclude certain VMs, for example, the below line excludes VMs beginning with 'abc' and 'other_vm'.
            if 'abc' not in vm['vm_name'] and 'other_vm' not in vm['vm_name']:
                print vm['vm_name']
                vm_names.append(vm["vm_name"])
        payload["names"] = vm_names
        payload_in_json = json.dumps(payload)
        server_response = self.session.post(add_vm_pd_url, data=payload_in_json)
        print ("Response code: %s" % server_response.status_code)
        return json.loads(server_response.text)
        
        # Add a specific VM to a protection domain.
    def specific_vm_to_pd(self):
        # Designate the location of the protection domain for "pd_name".
        add_VM_protection_domain_url = self.base_url\
           + "protection_domains/pd_name/protect_vms"
        print ("Added VM(s) to a protection domain on cluster %s" % self.ip_addr)
        payload = {}
        # Designate the name for the unprotected VM for "other_vm".
        payload["names"] = ["other_vm"]
        payload_in_json = json.dumps(payload)
        server_response = self.session.post(add_VM_protection_domain_url,
                                            data=payload_in_json)
        print ("Response code: %s" % server_response.status_code)
        return json.loads(server_response.text)

if __name__ == "__main__":
    try:
        # Start the execution of test cases.
        requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
        ntnx_test_rest_api = test_rest_api()
        #print ("hello world!")
        status, cluster = ntnx_test_rest_api.get_cluster_information()

        # Displays cluster authentication response and information.
        print("Status code: %s" % status)
        print("Text: ")
        print(json.dumps(cluster,indent=2))
        print("=")

        # Get specific cluster elements.
        print ("Name: %s" % cluster.get('name'))
        print ("ID: %s" % cluster.get('id'))
        print ("Cluster Ext IP Address:%s" % cluster.get('cluster_external_i_p_address'))
        print ("Number of Nodes: %s" % cluster.get('num_nodes'))
        print ("Version: %s" % cluster.get('version'))
        #Print hypervisor type.
        hypervisors = ""
        for hypervisor in cluster.get('hypervisor_types'):
            if( hypervisor == "kKvm" ):
                hypervisor_human_name = "AHV"
            elif( hypervisor == "kVMware" ):
                hypervisor_human_name = "ESXi"
            elif( hypervisor == "kHyperv" ):
                hypervisor_human_name = "Hyper-V"
            else:
                hypervisor_human_name = "Unknown"
            hypervisors = hypervisors + hypervisor_human_name + ','
        print ("Hypervisor Types: %s" % hypervisors.rstrip(','))

        print ("=")


        # Create a Protection Domain
        protection_domain = ntnx_test_rest_api.create_protection_domain()
        print ("Text: ")
        print(json.dumps(protection_domain,indent=2))
        print ("=" * 79)

        #Get list of unprotected VMs.
        unprotected_vms = ntnx_test_rest_api.get_unprotected_vms()
        print ("Text: ")
        print(json.dumps(unprotected_vms,indent=2))
        print ("=" * 79)

        # Add the list of uprotected VMs to a protection domain.
        added_vms = ntnx_test_rest_api.add_vm_to_pd()
        print ("Text: ")
        print(json.dumps(added_vms,indent=2))
        print ("=" * 79)

        # Add specific VM(s) to a protection domain.
        specific_vm = ntnx_test_rest_api.specific_vm_to_pd()
        print ("Text: ")
        print(json.dumps(specific_vm,indent=2))
        print ("=" * 79)

        print ("*COMPLETE*")

    except Exception as ex:
        print (ex)
    sys.exit(1)
