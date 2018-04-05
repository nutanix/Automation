#!/usr/bin/env python
#
# Copyright (c) 2014 Nutanix Inc. All rights reserved.
#
# This script shows how to authenticate, create protection domains, and add unprotected VMs to a protection domain provided by the PrismGateway.
# This script is ready to copy and paste for execution, but assign the variables within the script.
# WARNING: Be sure that when adding VMs to a protection domain, they are first unprotected.
# NOTE: You need a Python library called "requests" which can be available from
# the url: http://docs.python-requests.org/en/latest/user/install/#install

import pprint
import json
import os
import random
import requests
import sys
import traceback
#This block initializes the parameters for the request.
class TestRestApi():                
  def __init__(self):
    
    #Initializes the options and the logfile from GFLAGS.
    self.serverIpAddress = "ip_address"
    self.username = "username"
    self.password = "password"
    # Base URL at which REST services are hosted in Prism Gateway.
    BASE_URL = 'https://%s:9440/PrismGateway/services/rest/v1/'
    self.base_url = BASE_URL % self.serverIpAddress
    self.session = self.get_server_session(self.username, self.password)

  def get_server_session(self, username, password):
    
    #Creating REST client session for server connection, after globally setting
    #Authorization, content type, and character set for the session.
    session = requests.Session()
    session.auth = (username, password)
    session.verify = False
    session.headers.update(
        {'Content-Type': 'application/json; charset=utf-8'})
    return session

#Prints the cluster information and loads JSON objects to be formatted.

  def getClusterInformation(self):

    #This sets up 'pretty print' for the object.
    pp = pprint.PrettyPrinter(indent=2)
    clusterURL = self.base_url + "/cluster"
    print "Getting cluster information for cluster %s" % self.serverIpAddress
    serverResponse = self.session.get(clusterURL)
    print "Response code: %s" % serverResponse.status_code
    return serverResponse.status_code, json.loads(serverResponse.text)

#Creates a protection domain with assigned name.

  def createProtectionDomain(self):
       
    protectionDomainURL = self.base_url + "/protection_domains"
    print "Created a protection domain on cluster %s" % self.serverIpAddress
    payload = {}
    #Designate a protection domain name.
    payload["value"] = "pd_name"					
    payloadInJson = json.dumps(payload)
    serverResponse = self.session.post(protectionDomainURL, data=payloadInJson)
    print "Response code: %s" % serverResponse.status_code
    return json.loads(serverResponse.text)
    
#Get the list of unprotected VMs.

  def getUnprotectedVMs(self):
  
    unprotectedVMURL = self.base_url + "/protection_domains/unprotected_vms/"
    print "List of unprotected VMs in cluster %s" % self.serverIpAddress
    serverResponse = self.session.get(unprotectedVMURL)
    print "Response code: %s" % serverResponse.status_code
    return json.loads(serverResponse.text)
    
#Add the entire list of unprotected VMs to Protection Domain. This script will exclude Controller VMs. 
#If you have VMs on Metro Availability protection domains thien the cluster will give you a warning, 
#ignore those VMs, and continue to add the other unprotected VMs.

  def addVMtoPD(self):
    
   #Designate the location of the protection domain for "pd_name".
    addVMtoPDURL = self.base_url + "/protection_domains/pd_name/protect_vms"  
    print "Added unprotected VMs to a Protection Domain on cluster %s" % self.serverIpAddress
    payload = {}
    vms = testRestApi.getUnprotectedVMs()
    vmNames = []
   #Designate the name for the unprotected VM.
    for vm in vms:
        vmNames.append(vm["vm_name"])					
    payload["names"] = vmNames
    payloadInJson = json.dumps(payload)
    serverResponse = self.session.post(addVMtoPDURL, data=payloadInJson)
    print "Response code: %s" % serverResponse.status_code
    return json.loads(serverResponse.text)
   
#Add a specific VM to a protection domain. 
  def specificVMtoPD(self):
    #Designate the location of the protection domain for "pd_name".
    addVMprotectionDomainURL = self.base_url + "protection_domains/pd_name/protect_vms"  
    print "Added specific VM(s) to a protection domain on cluster %s" % self.serverIpAddress
    payload = {}
    #Designate the name for the unprotected VM.
    payload["names"] = ["vm_name"]
    payloadInJson = json.dumps(payload)
    serverResponse = self.session.post(addVMprotectionDomainURL, data=payloadInJson)
    print "Response code: %s" % serverResponse.status_code
    return json.loads(serverResponse.text)
    
if __name__ == "__main__":
  try:
    #Set the Pretty Printer variable to format data.
    pp = pprint.PrettyPrinter(indent=2)
    
    # Start the execution of test cases.
    testRestApi = TestRestApi()
    print ("=" * 79)
    status, cluster = testRestApi.getClusterInformation()
    print ("=" * 79)
    
    #Displays cluster authentication response and information.
    print "Status code: %s" % status
    print "Text: " # %s" % cluster
    pp.pprint(cluster)
    print ("=" * 79)
    
    #Get specific cluster elements.
    print "Name: %s" % cluster.get('name')
    print "ID: %s" % cluster.get('id')
    print "Cluster External IP Address: %s" % cluster.get('clusterExternalIPAddress')
    print "Number of Nodes: %s" % cluster.get('numNodes')
    print "Version: %s" % cluster.get('version')
    print "Hypervisor Types: %s" % cluster.get('hypervisorTypes')
    print ("=" * 79)

    #Create a Protection Domain
    protection_domain = testRestApi.createProtectionDomain()
    print "Text: "
    pp.pprint(protection_domain)
    print ("=" * 79)

    #Get list of unprotected VMs.
    unprotected_vms = testRestApi.getUnprotectedVMs()
    print "Text: "
    pp.pprint(unprotected_vms)
    print ("=" * 79)

    
    #Add the list of uprotected VMs to a protection domain.
    added_vms = testRestApi.addVMtoPD()
    print "Text: "
    pp.pprint(added_vms)
    print ("=" * 79)
    
    #Add specific VM(s) to a protection domain.
    specific_vm = testRestApi.specificVMtoPD()
    print "Text: "
    pp.pprint(specific_vm)
    print ("=" * 79)
    
    print ("*" * 79)
    
    
  except Exception as ex:
    print ex
    sys.exit(1)

