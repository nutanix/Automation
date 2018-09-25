#!/usr/bin/env python3.6

"""

    import_blueprints.py

    Connect to a Nutanix Prism Central instance and import all Nutanix Calm blueprints from a specified directory (or current directory if unspecified).

    Useful as a final step after you've dumped your blueprints using save_blueprints.py e.g. if you're setting up a temporary or new Prism Central instance during testing.

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
from time import localtime, strftime, mktime
import urllib3
import glob
import re

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
    global directory

    # process the command-line arguments
    parser = argparse.ArgumentParser(description='Export all Calm blueprints to JSON files')
    parser.add_argument('pc_ip',help='Prism Central IP address')
    parser.add_argument('-u', '--username',help='Prism Central username')
    parser.add_argument('-p', '--password',help='Prism Central password')
    parser.add_argument('-d', '--directory',help='Blueprint directory')

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

    if args.directory:
        directory = args.directory
    else:
        directory = '.'

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
        elif not directory:
            raise Exception("Blueprint directory is required.")
        else:
            
            # get a list of all blueprints in the specified directory
            blueprint_list = glob.glob(f'{directory}/*.json')

            if(len(blueprint_list) > 0):

                # make sure the user knows what's happening ... ;-)
                print(f"\n{len(blueprint_list)} JSON files found. Starting import ...\n")

                # go through the blueprint JSON files found in the specified directory
                for blueprint in blueprint_list:
                    start_time = localtime()
                    # open the JSON file from disk
                    with open(f"{blueprint}", "r") as f:
                        raw_json = f.read()
                        raw_json = re.sub(r'"status":{},','',raw_json)
                        raw_json = re.sub(r'"status": {},','',raw_json)
                        # try and get the blueprint name
                        # if this fails, it's either a corrupt/damaged/edited blueprint JSON file or not a blueprint file at all
                        try:
                            blueprint_name = json.loads(raw_json)['spec']['name']
                        except json.decoder.JSONDecodeError:
                            print(f"{blueprint}: Unprocessable JSON file found. Is this definitely a Nutanix Calm blueprint file?")
                            sys.exit()
                        # got the blueprint name - this is probably a valid blueprint file
                        # we can now continue and try the upload
                        client = apiclient.ApiClient(
                            'post',
                            cluster_ip,
                            "blueprints/import_json",
                            str(raw_json),
                            username,
                            password
                        )
                        try:
                            json_result = client.get_info()
                        except json.decoder.JSONDecodeError:
                            print(f'{blueprint}: No processable JSON response available.')
                            sys.exit()
                        
                    # calculate how long the import took
                    end_time = localtime()
                    difference = mktime(end_time) - mktime(start_time)

                    try:
                        message = f"{blueprint}: {json_result['message_list'][0]['message']}."
                    except KeyError:
                        message = f"{blueprint}: Successfully imported in {difference} seconds."

                    # tell the user what happened, including any failures
                    print(f"{message}")

            else:
                print(f"\nNo JSON files found in {directory} ... nothing to import!")
                
            # w00t
            print("\nFinished!\n")

if __name__ == "__main__":
    main()