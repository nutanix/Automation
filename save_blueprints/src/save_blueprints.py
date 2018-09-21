#!/usr/bin/env python3.6

"""

    save_blueprints.py

    Connect to a Nutanix Prism Central instance, grab all Calm blueprints and save them to JSON files.

    You would need to *heavily* modify this script for use in a production environment so that it contains appropriate error-checking and exception handling.

"""

__author__ = "Chris Rasmussen @ Nutanix"
__version__ = "1.0"
__maintainer__ = "Chris Rasmussen @ Nutanix"
__email__ = "crasmussen@nutanix.com"
__status__ = "Development/Demo"

# default modules
import sys
import json
import getpass
import argparse
from time import localtime, strftime
import urllib3

# custom modules
import apiclient

def set_options():
    global ENTITY_RESPONSE_LENGTH
    # set ENTITY_RESPONSE_LENGTH to the maximum number of blueprints you want to export
    # this is only required since the v3 list APIs will only return 20 entities by default
    ENTITY_RESPONSE_LENGTH = 50

def get_options():
    global cluster_ip
    global username
    global password

    # process the command-line arguments
    parser = argparse.ArgumentParser(description='Export all Calm blueprints to JSON files')
    parser.add_argument('pc_ip',help='Prism Central IP address')
    parser.add_argument('-u', '--username',help='Prism Central username')
    parser.add_argument('-p', '--password',help='Prism Central password')

    args = parser.parse_args()

    # validate the arguments to make sure all required info has been supplied
    if args.username:
        username = args.username
    else:
        username = input('Please enter your Prism Central username: ')

    if args.password:
        password = args.password
    else:
        password = getpass.getpass()

    cluster_ip = args.pc_ip

def main():
        
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
            
            # do a preliminary check to see if this is AOS or C
            # not used in this script but is could be useful for later modifications
            client = apiclient.ApiClient('post', cluster_ip, "clusters/list", '{ "kind": "cluster" }', username, password )
            results = client.get_info()
            is_ce = False
            for cluster in results["entities"]:
                if "-ce-" in cluster["status"]["resources"]["config"]["build"]["full_version"]:
                    is_ce = True

            endpoints = {}
            endpoints['blueprints'] = [ 'blueprint', ( f'"length":{ENTITY_RESPONSE_LENGTH}' ) ]

            # get all blueprints
            for endpoint in endpoints:
                if endpoints[endpoint][1] != '':
                    client = apiclient.ApiClient('post', cluster_ip, ( f"{endpoints[endpoint][0]}s/list" ), ( f'{{ "kind": "{endpoints[endpoint][0]}", {endpoints[endpoint][1]} }}' ), username, password )
                else:
                    client = apiclient.ApiClient('post', cluster_ip, ( f"{endpoints[endpoint][0]}s/list" ), ( f'{{ "kind": "{endpoints[endpoint][0]}" }}' ), username, password )
                results = client.get_info()

            # make sure the user knows what's happening ... ;-)
            print(f"\n{len(results['entities'])} blueprints collected from {cluster_ip}\n")

            # go through all the blueprints and export them to appropriately named files
            # filename will match the blueprint name and should work find if blueprint name contains spaces (tested on Ubuntu Linux)
            for blueprint in results['entities']:
                day = strftime("%d-%b-%Y", localtime())
                time = strftime("%H%M%S", localtime())
                blueprint_filename = f"{day}_{time}_{blueprint['status']['name']}.json"
                client = apiclient.ApiClient(
                    'get',
                    cluster_ip,
                    f"blueprints/{blueprint['status']['uuid']}/export_file",
                    '{ "kind": "cluster" }',
                    username,
                    password
                )
                exported_json = client.get_info()
                with open( f"./{blueprint_filename}", "w" ) as f:
                    json.dump(exported_json,f)
                    print(f"Successfully exported blueprint '{blueprint['status']['name']}'")
            print("\nFinished!\n")

if __name__ == "__main__":
    main()