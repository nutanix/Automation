### Witness Script ###
# Author: Christian Johannsen
# Version: 0.1
#
# Note: Certificate verfication is set False
###

import listen
import config
import json 
import requests

def promote(site):
    #supress the security warnings
    requests.packages.urllib3.disable_warnings()
        
    #first identify the site of the 'last' signal
    if (site=="siteA"):
        #set base_url to remote site
        base_url = "https://" + config.metro["siteB"] + ":9440/PrismGateway/services/rest/v1/"
        requests.get(base_url, verify=False)
    elif (site=="siteB"):
        #set base_url to remote site
        base_url = "https://" + config.metro["siteA"] + ":9440/PrismGateway/services/rest/v1/"
        requests.get(base_url, verify=False)
        
    s = requests.Session()
    s.auth = (config.cred["username"], config.cred["password"])
    s.headers.update({'Content-Type': 'application/json; charset=utf-8'})
    
    r = s.post(base_url + 'protection_domains/' + config.metro["pdName"] + "/promote?skipRemoteCheck=false", verify=False)  
    print r.content

if __name__ == '__main__':
    site = listen.receiver()
    try:
        promote(site)
    except:
        print "Exception"
        raise
