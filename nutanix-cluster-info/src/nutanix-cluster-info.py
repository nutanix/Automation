#!/usr/bin/env python3.6

"""

    nutanix-cluster-info.py

    Connect to a Nutanix Prism Central instance, grab some high-level details then generate a PDF from it

    The intention is to use this script as very high-level and *unofficial* as-built documentation for sites using Nutanix Prism Central
    As of Nutanix AOS 5.5, this should be everyone!  :)

    You would need to *heavily* modify this script for use in a production environment so that it contains appropriate error-checking, exception handling and data collection

"""

__author__ = "Chris Rasmussen @ Nutanix"
__version__ = "3.0"
__maintainer__ = "Chris Rasmussen @ Nutanix"
__email__ = "crasmussen@nutanix.com"
__status__ = "Development/Demo"

# required modules
import os
import sys
import json
import os.path
import socket
import getpass
import argparse
from time import localtime, strftime
from string import Template

import urllib.request
import urllib.parse
import urllib3
import requests
from requests.auth import HTTPBasicAuth
from weasyprint import HTML, CSS
from weasyprint.fonts import FontConfiguration

def set_options():
    global ENTITY_RESPONSE_LENGTH
    ENTITY_RESPONSE_LENGTH = 50
    #global DISPLAY_OUTPUT
    #DISPLAY_OUTPUT = False
    global html_rows
    html_rows = {}
    global entity_totals
    entity_totals = {}
    
def get_options():
    global cluster_ip
    global username
    global password
    global DISPLAY_OUTPUT

    parser = argparse.ArgumentParser('Connect to Prism Central, gather some details and generate PDF documentation')
    parser.add_argument('pc_ip', help='Prism Central IP address')
    parser.add_argument('-u', '--username', help='Prism Central username')
    parser.add_argument('-p', '--password', help='Prism Central password')
    parser.add_argument('-o', '--output', help='Set to 1 to display cluster info after generating the PDF')

    args = parser.parse_args()

    if args.username:
        username = args.username
    else:
        username = input('Please enter your Prism Central username: ')

    if args.password:
        password = args.password
    else:
        password = getpass.getpass()

    if args.output:
        DISPLAY_OUTPUT = args.output
    else:
        DISPLAY_OUTPUT = 0

    cluster_ip = args.pc_ip
    print("\n")

class ApiClient():

    def __init__(self, cluster_ip, request, body, username, password):
        self.cluster_ip = cluster_ip
        self.username = username
        self.password = password
        self.base_url = "https://%s:9440/api/nutanix/v3" % (self.cluster_ip)
        self.entity_type = request
        self.request_url = "%s/%s" % (self.base_url, request)
        self.body = body

    def get_info(self):

        print("Requesting '%s' ..." % self.entity_type )        
        headers = {'Content-Type': 'application/json; charset=utf-8'}
        try:
            r = requests.post(self.request_url, data=self.body, verify=False, headers=headers, auth=HTTPBasicAuth(self.username, self.password), timeout=10)
        except requests.ConnectTimeout:
            print('Connection timed out while connecting to %s. Please check your connection, then try again.' % self.cluster_ip)
            sys.exit()
        except requests.ConnectionError:
            print('An error occurred while connecting to %s. Please check your connection, then try again.' % self.cluster_ip)
            sys.exit()
        except requests.HTTPError:
            print('An HTTP error occurred while connecting to %s. Please check your connection, then try again.' % self.cluster_ip)
            sys.exit()
        
        if r.status_code >= 500:
            print('An HTTP server error has occurred (%s)' % r.status_code ) 
        else:
            if r.status_code == 401:
                print('An authentication error occurred while connecting to %s. Please check your credentials, then try again.' % self.cluster_ip)
                sys.exit()
            if r.status_code >= 401:
                print('An HTTP client error has occurred (%s)' % r.status_code )
                sys.exit()
            else:
                print('Connected and authenticated successfully.')
        
        return(r.json())
        
# load the JSON file
# at this point we have already confirmed that cluster.json exists
# this method isn't used right now
def process_json():
    with open('cluster.json') as data_file:
        return json.load(data_file)

# load JSON data from an on-disk file
def load_json(file):
    with open(file) as data_file:
        return json.load(data_file)

# do the actual PDF generation
def generate_pdf_v2( json_results ):
    # the current time right now
    day=strftime("%d-%b-%Y", localtime())
    time=strftime("%H%M%S", localtime())
    now="%s_%s" % (day, time)

    # the name of the PDF file to generate
    pdf_file="%s_prism_central.pdf" % (now)

    #
    # the next block parses some of the Prism Central info that currently exists as individual arrays
    #

    for row_label in [ 'vm', 'subnet', 'cluster', 'project', 'network_security_rules', 'image', 'host', 'blueprint', 'app' ]:
        print(f"{row_label}")
        html_rows[row_label] = ""
        entity_totals[row_label] = 0
    
    print("\n")
    
    for json_result in json_results:
        ######
        # VM #
        ######
        if json_result[0] == 'vm':
            print("Number of VMs: %s" % json_result[1]["metadata"]["total_matches"])
            entity_totals['vm'] = json_result[1]["metadata"]["total_matches"]
            for vm in json_result[1]["entities"]:
                try:
                    description = vm["spec"]["description"]
                except KeyError:
                    description = "None provided"
                if DISPLAY_OUTPUT:
                    display = "%s with description %s" % (vm["spec"]["name"], description)
                    print(display)
                html_rows['vm'] = html_rows['vm'] + "<tr><td>%s:%s</td><td>%s</td></tr>" % ( vm["spec"]["cluster_reference"]["name"], vm["spec"]["name"], description )
            print("\n")
        ##########
        # SUBNET #
        ##########
        elif json_result[0] == 'subnet':
            entity_totals['subnet'] = json_result[1]["metadata"]["total_matches"]
            print("Number of subnets: %s" % json_result[1]["metadata"]["total_matches"])
            for subnet in json_result[1]["entities"]:
                if DISPLAY_OUTPUT:
                    display = "%s on cluster %s" % (subnet["spec"]["name"], subnet["spec"]["cluster_reference"]["name"])
                    print(display)
                html_rows['subnet'] = html_rows['subnet'] + "<tr><td>%s</td><td>%s</td></tr>" % ( subnet["spec"]["name"], subnet["spec"]["cluster_reference"]["name"] )
            print("\n")
        ###########
        # PROJECT #
        ###########
        elif json_result[0] == 'project':
            entity_totals['project'] = json_result[1]["metadata"]["total_matches"]
            print("Number of projects: %s" % json_result[1]["metadata"]["total_matches"])
            vm_total = 0
            cpu_total = 0
            storage_total = 0
            memory_total = 0
            html_rows['project'] = ""
            for project in json_result[1]["entities"]:

                if DISPLAY_OUTPUT:
                    display = "Project: %s" % (project["spec"]["name"])
                    print( display )
                html_rows['project'] = html_rows['project'] + "<tr><td>%s</td>" % project["spec"]["name"]

                try:

                    if( len( project["status"]["resources"]["resource_domain"]["resources"] ) > 0 ):
                        for resource in project["status"]["resources"]["resource_domain"]["resources"]:
                            if resource["resource_type"] == "VMS":
                                vm_total = resource["value"]
                            elif resource["resource_type"] == "VCPUS":
                                cpu_total = resource["value"]
                            elif resource["resource_type"] == "STORAGE":
                                storage_total = resource["value"] /1024/1024/1024
                            elif resource["resource_type"] == "MEMORY":
                                memory_total = resource["value"] /1024/1024/1024
                        html_rows['project'] = html_rows['project'] + "<td>%s</td><td>%s</td><td>%s</td><td>%s</td>" % ( vm_total, cpu_total, storage_total, memory_total )
                    else:
                        html_rows['project'] = html_rows['project'] + "<td>0</td><td>0</td><td>0</td><td>0</td>"

                except KeyError:
                        html_rows['project'] = html_rows['project'] + "<td>0</td><td>0</td><td>0</td><td>0</td>"

                html_rows['project'] = html_rows['project'] + "</tr>"





            print("\n")
        #########################
        # NETWORK_SECURITY_RULE #
        #########################
        elif json_result[0] == 'network_security_rule':
            entity_totals['network_security_rules'] = json_result[1]["metadata"]["total_matches"]
            print("Number of network security rules: %s" % json_result[1]["metadata"]["total_matches"])
            for network_security_rule in json_result[1]["entities"]:
                if DISPLAY_OUTPUT:
                    display = "%s" % ( network_security_rule["spec"]["name"] )
                    print(display)
                html_rows['network_security_rules'] = html_rows['network_security_rules'] + "<tr><td>%s</td></tr>" % network_security_rule["spec"]["name"]
            print("\n")
        #########
        # IMAGE #
        #########
        elif json_result[0] == 'image':
            entity_totals['image'] = json_result[1]["metadata"]["total_matches"]
            print("Number of images: %s" % json_result[1]["metadata"]["total_matches"])
            for image in json_result[1]["entities"]:
                if DISPLAY_OUTPUT:
                    display = "%s (%s)" % ( image["status"]["name"], image["status"]["resources"]["image_type"] )
                    print( display )
                html_rows['image'] = html_rows['image'] + "<tr><td>%s</td><td>%s</td></tr>" % ( image["status"]["name"], image["status"]["resources"]["image_type"] )
            print("\n")
        ########
        # HOST #
        ########
        elif json_result[0] == 'host':
            entity_totals['host'] = json_result[1]["metadata"]["total_matches"]
            print("Number of hosts: %s" % json_result[1]["metadata"]["total_matches"])
            for host in json_result[1]["entities"]:
                if DISPLAY_OUTPUT:
                    display = "Host %s, running %s VMs (IP %s, CVM IP %s, S/N %s)" % ( host["status"]["name"], host["status"]["resources"]["hypervisor"]["num_vms"], host["status"]["resources"]["controller_vm"]["ip"], host["status"]["resources"]["hypervisor"]["ip"], host["status"]["resources"]["serial_number"] )
                    print( display )
                try:
                    html_rows['host'] = html_rows['host'] + "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>" % ( host["status"]["name"], host["status"]["resources"]["serial_number"], host["status"]["resources"]["hypervisor"]["ip"], host["status"]["resources"]["controller_vm"]["ip"], host["status"]["resources"]["hypervisor"]["num_vms"] )
                except KeyError:
                    html_rows['host'] = html_rows['host'] + "<tr><td colspan=\"5\">An error occurred while parsing host with IP address %s. This is expected when trying to check hypervisor version on Prism Central 5.9 and later.</td></tr>" % ( host["status"]["resources"]["controller_vm"]["ip"] )
            print("\n")
        ###########
        # CLUSTER #
        ###########
        elif json_result[0] == 'cluster':
            entity_totals['cluster'] = json_result[1]["metadata"]["total_matches"]
            print("\nRegistered clusters: %s" % json_result[1]["metadata"]["total_matches"])
            for cluster in json_result[1]["entities"]:
                if "external_ip" in cluster["spec"]["resources"]["network"]:
                    cluster_ip = cluster["spec"]["resources"]["network"]["external_ip"]
                else:
                    cluster_ip = "N/A"
                if cluster["status"]["resources"]["config"]["service_list"][0] == "AOS":
                    prefix = "Cluster:"
                    html_prefix = "AOS"
                else:
                    prefix = "Prism Central:"
                    html_prefix = "Prism Central"
                if DISPLAY_OUTPUT:
                    display = "%s %s (External IP: %s)" % (prefix, cluster["spec"]["name"], cluster_ip)
                    print( display )
                
                if "-ce-" in cluster["status"]["resources"]["config"]["build"]["full_version"]:
                    is_ce = "Yes"
                else:
                    is_ce = "No"
                html_rows['cluster'] = html_rows['cluster'] + "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td>" % ( html_prefix, cluster["spec"]["name"], cluster_ip, cluster["status"]["resources"]["config"]["build"]["version"], is_ce )                
            print("\n")
        #############
        # BLUEPRINT #
        #############
        elif json_result[0] == 'blueprint':
            entity_totals['blueprint'] = json_result[1]["metadata"]["total_matches"]
            print("Number of blueprints: %s" % json_result[1]["metadata"]["total_matches"])
            for blueprint in json_result[1]["entities"]:
                if blueprint["status"]["deleted"] == False:
                    status = blueprint["status"]["state"]
                    if "project_reference" in blueprint["metadata"]:
                        project = blueprint["metadata"]["project_reference"]["name"]
                    else:
                        project = "N/A"
                    if DISPLAY_OUTPUT:
                        display = "Blueprint: %s in project %s (%s)" % (blueprint["status"]["name"], project, status )
                        print( display )
                    html_rows['blueprint'] = html_rows['blueprint'] + "<tr><td>%s</td><td>%s</td><td>%s</td></tr>" % ( blueprint["status"]["name"], project, status )
            print("\n")
        #######
        # APP #
        #######
        elif json_result[0] == 'app':
            entity_totals['app'] = json_result[1]["metadata"]["total_matches"]
            print("Number of apps: %s" % json_result[1]["metadata"]["total_matches"])
            for app in json_result[1]["entities"]:
                if( app["status"]["state"].upper() != "DELETED" ):
                    if DISPLAY_OUTPUT:
                        display = "App (%s): %s in project %s" % ( app["status"]["state"].upper(), app["status"]["name"], app["metadata"]["project_reference"]["name"] )
                        print( display )
                    html_rows['app'] = html_rows['app'] + "<tr><td>%s</td><td>%s</td><td>%s</td></tr>" % ( app["status"]["name"], app["metadata"]["project_reference"]["name"], app["status"]["state"].upper() )
            print("\n")
      
    print("\n")
    
    # specify the HTML page template
    # at this point we have already verified that template.html exists, at least

    current_path = os.path.dirname(sys.argv[0])

    if os.path.isfile( f"{current_path}/../templates/nutanixv3.html" ):
        template_name = f"{current_path}/../templates/nutanixv3.html"
    else:
        print("Template not found")
        sys.exit()
        
    # load the HTML content from the template
    with open( template_name, "r") as data_file:
        source_html = Template( data_file.read() )
                                    
    # substitute the template variables for actual cluster data
    template = source_html.safe_substitute(
        day=day,
        now=time,
        username=getpass.getuser(),
        clusters=str(html_rows['cluster']),
        vms=str(html_rows['vm']),
        subnets=str(html_rows['subnet']),
        projects=str(html_rows['project']),
        network_security_rules=str(html_rows['network_security_rules']),
        images=str(html_rows['image']),
        hosts=str(html_rows['host']),
        blueprints=str(html_rows['blueprint']),
        apps=str(html_rows['app']),
        # totals
        cluster_total=str(entity_totals['cluster']),
        vm_total=str(entity_totals['vm']),
        subnet_total=str(entity_totals['subnet']),
        project_total=str(entity_totals['project']),
        network_security_rule_total=str(entity_totals['network_security_rules']),
        image_total=str(entity_totals['image']),
        host_total=str(entity_totals['host']),
        blueprint_total=str(entity_totals['blueprint']),
        app_total=str(entity_totals['app']),
        computer_name=socket.gethostname()
    )
    
    # generate the final PDF file
    convert_html_to_pdf(template, pdf_file)

    print("Finished generating PDF file: %s " % pdf_file)
    print("\n")

# utility function for HTML to PDF conversion
def convert_html_to_pdf(source_html, output_filename):
    # open output file for writing (truncated binary)
    # result_file = open(output_filename, "w+b")
        
    font_config = FontConfiguration()
        
    x=HTML(string=source_html)
    x.write_pdf(output_filename,stylesheets=[CSS(string='''
        h1 { color: #3f6fb4; }
        body { font-family: sans-serif; font-size: 80%; line-height: 1.2em; }
        #main_content { margin: 0 auto; text-align: left; width: 75%; }
        table{ width: 100%; border-bottom: 1px solid #ddd; padding-bottom: 20px; }
        tr.final { border-bottom: 1px solid #eee; padding: 3px 0; }
        tr.footer { padding: 5px; text-align: center; }
        tr.tr_header { font-weight: bold; }
        td,p { padding: 3px; }
        div#footer_content { text-align: center; margin-top: 20px; }
    ''',font_config=font_config)])
    
def show_intro():
    print( """
%s:

Connect to a Nutanix Prism Central instance, grab some high-level details then generate a PDF from it

Intended to generate a very high-level and *unofficial* as-built document for an existing Prism Central instance.

This script is GPL and there is *NO WARRANTY* provided with this script ... AT ALL.  You can use and modify this script as you wish, but please make sure the changes are appropriate for the intended environment.

Formal documentation should always be generated using best-practice methods that suit your environment.
""" % sys.argv[0])

def main():

    current_path = os.path.dirname(sys.argv[0])

    if os.path.isfile(f"{current_path}/../templates/nutanixv3.html"):
        show_intro()

        # first we must make sure the cluster JSON file exists in the currect directory
        # if os.path.isfile( 'cluster.json' ) == True:
        
        # set the global options
        set_options()

        # get the cluster connection info
        get_options()

        # disable insecure connection warnings
        # please be advised and aware of the implications in a production environment!
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

        # make sure all required info has been provided
        if not cluster_ip:
            raise Exception("Cluster IP is required.")
        elif not username:
            raise Exception("Username is required.")
        elif not password:
            raise Exception("Password is required.")
        else:
            
            # do a preliminary check to see if this is AOS or CE
            client = ApiClient(cluster_ip, "clusters/list", '{ "kind": "cluster" }', username, password )
            results = client.get_info()
            is_ce = False
            for cluster in results["entities"]:
                if "-ce-" in cluster["status"]["resources"]["config"]["build"]["full_version"]:
                    is_ce = True
                    
            # note that the entity types available for AOS vs CE will be different
            # please make sure to check these before running against your Prism Central instance!
            
            length = ENTITY_RESPONSE_LENGTH

            json_results = []
            endpoints = {}
            endpoints['clusters'] = [ 'cluster', ( '"length":%s' % length ) ]
            endpoints['subnets'] = [ 'subnet', ( '"length":%s'% length ) ]
            endpoints['projects'] = [ 'project', ( '"length":%s' % length ) ]
            endpoints['vms'] = [ 'vm', ( '"length":%s' % length ) ]
            endpoints['network_security_rules'] = [ 'network_security_rule', ( '"length":%s' % length ) ]
            endpoints['images'] = [ 'image', ( '"length":%s' % length ) ]
            
            if( not is_ce ):
                endpoints['hosts'] = [ 'host', ( '"length":%s' % length ) ]
                endpoints['apps'] = [ 'app', ( '"length":%s' % length ) ]
                endpoints['blueprints'] = [ 'blueprint', ( '"length":%s' % length ) ]

            for endpoint in endpoints:
                if endpoints[endpoint][1] != '':
                    client = ApiClient(cluster_ip, ( "%ss/list" % ( endpoints[endpoint][0] ) ), ( '{ "kind": "%s", %s }' % ( endpoints[endpoint][0], endpoints[endpoint][1] ) ), username, password )
                else:
                    client = ApiClient(cluster_ip, ( "%ss/list" % ( endpoints[endpoint][0] ) ), ( '{ "kind": "%s" }' % ( endpoints[endpoint][0] ) ), username, password )
                results = client.get_info()
                json_results.append( [ endpoints[endpoint][0], results ] )
                
            generate_pdf_v2( json_results )

    else:
        print("\nNo HTML templates were found in the 'templates' directory.  You'll need one of these to continue.\n")

if __name__ == "__main__":
    main()
