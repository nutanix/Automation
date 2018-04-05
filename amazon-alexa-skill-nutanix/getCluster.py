/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

from __future__ import print_function
import argparse
import time
import datetime
import json
import sys
import boto3
import os
import requests
import logging
import rds_config
import pymysql

# rds settings
rds_host = ''
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name

# Cluster connection settings
ntnx_clusterIP = ''
ntnx_password = ''
ntnx_username = ''
ntnx_clusterPort = ''
ntnx_nickname = ''

# Speechlets
NUTANIX = "newtanicks"
INTELNUC = "intel nuck"

logger = logging.getLogger()
logger.setLevel(logging.INFO)

API_PRISM = '/PrismGateway/services/rest/v1'
API_PRISM_V2 = "/api/nutanix/v2.0/"


def __supress_security():
    # supress security warnings
    requests.packages.urllib3.disable_warnings()


def __htpp_request(base_url):
    # supress security warnings
    __supress_security()

    s = requests.Session()
    s.auth = (ntnx_username, ntnx_password)
    s.headers.update({'Content-Type': 'application/json; charset=utf-8'})
    return json.dumps(s.get(base_url, verify=False).json(), sort_keys=True)


def __request_clusters(cluster_ip_address, cluster_port):
    base_url = "https://" + cluster_ip_address + ":" + str(cluster_port) + API_PRISM + "/clusters/"
    return __htpp_request(base_url)


def __request_cluster_hosts(cluster_ip_address, cluster_port):
    base_url = "https://" + cluster_ip_address + ":" + str(cluster_port) + API_PRISM + "/hosts/"
    return __htpp_request(base_url)


def __request_cluster_vms(cluster_ip_address, cluster_port):
    base_url = "https://" + cluster_ip_address + ":" + str(cluster_port) + API_PRISM + "/vms/"
    return __htpp_request(base_url)


def __request_cluster_alerts(cluster_ip_address, cluster_port, type):
    # Type must be'warning' or 'critical'
    base_url = "https://" + cluster_ip_address + ":" + str(cluster_port) + API_PRISM + "/clusters/alerts?severity=" + type
    return __htpp_request(base_url)


def __set_rds_host_region(event):
    # Define request source and assign correct RDS instance
    global rds_host
    if event['request']['locale'] == "en-US":
        rds_host = "nutanix-beta.cel0uwqzzgpj.us-east-1.rds.amazonaws.com"
    elif event['request']['locale'] == "en-GB":
        rds_host = "nutanix-beta-eu.cpdl28a97nyk.eu-west-1.rds.amazonaws.com"


def __request_userID_data(userId):

    global ntnx_clusterIP
    global ntnx_username
    global ntnx_password
    global ntnx_clusterPort
    global ntnx_nickname

    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    cur = conn.cursor()
    logger.info("RDS connection sucessfull")

    try:
        cur.execute("SELECT * FROM alexa.alexa_beta WHERE alexa_userId = (%s)", (userId))
        data = cur.fetchone()
        if data:
            ntnx_clusterIP = data[2]
            ntnx_username = data[3]
            ntnx_password = data[4]
            ntnx_nickname = data[5]
            ntnx_clusterPort = data[6]
            return data
        else:
            #
            #
            # Must be changed once only registered clusters are accepted
            #
            #
            logger.error(userId)
            userId = "amzn1.ask.account.AGGNJ6WTSGQ5VEWK2J4FAHXPL477LF35VWR6KMIEDMFAVBYZR5CT5GO4U73ZWSEAKONHR3KW7NKUA4GATOTIZB24FP6L4BPD4UVENI23YUSCMOJAWYRWDG6ZDJNIRH4VSENFFXUEO2TJ24EEOF7NXDYR5RH7YDQA7RHIXTKEL7625UZ25YTWMZGWGV26C4PM6G7DYCZNFC7S2AY"
            cur.execute("SELECT * FROM alexa.alexa_beta WHERE alexa_userId = (%s)", (userId))
            data = cur.fetchone()
            if data:
                ntnx_clusterIP = data[2]
                ntnx_username = data[3]
                ntnx_password = data[4]
                ntnx_nickname = 'stranger'
                ntnx_clusterPort = data[6]
                return data
    except Exception as e:
        logger.error(e)
        return None
    finally:
        cur.close()
        conn.close()


def cluster_registration(intent, session):
    session_attributes = {}
    card_title = "Cluster Registration"
    card_content = "Use the URL below to register your Nutanix cluster \n http://myvirtualcloud.net/alexa-skill-for-nutanix-registration-form \n Your Alexa ID for cluster registration is " + session['user']['userId']
    speech_output = '<speak><p>Please check your Alexa card to retrieve the Alexa user <say-as interpret-as="spell-out">id</say-as>, and follow the registration instructions.</p></speak>'
    reprompt_text = ""
    should_end_session = True
    return build_response(session_attributes, build_speechlet_response(
        card_title, False, card_content, speech_output, reprompt_text, should_end_session))


def get_internal_error_response():
    session_attributes = {}
    card_title = "Internal Error"
    card_content = ""
    speech_output = '<speak><p>Sorry, there was an internal error, or the Alexa user<say-as interpret-as="spell-out">id</say-as> does not have a ' + NUTANIX + ' cluster association</p></speak>'
    reprompt_text = ""
    should_end_session = True
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_welcome_response():
    session_attributes = {}
    card_title = "Welcome"
    card_content = ""
    speech_output = '<speak><p>Hello ' + ntnx_nickname + ', welcome to the unofficial Alexa Skills for ' + NUTANIX + '</p>' + \
                    '<p>If you need help, say help</p></speak>'
    reprompt_text = '<speak><p>I didnt hear your request.</p></speak>'
    should_end_session = False
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_help_response():
    session_attributes = {}
    card_title = "Help"
    card_content = ""
    speech_output = '<speak><p>You may ask for the cluster summary saying, Alexa, ask ' + NUTANIX + ' unofficial for cluster summary,</p>' + \
                    '<p>or you may ask for a specific property. Alexa, ask ' + NUTANIX + ' unofficial for cluster utilization.</p>' + \
                    '<p>You may also combine a property and a type. Alexa, ask ' + NUTANIX + ' unofficial for cluster critical alerts.</p>' + \
                    '<p>You always need to use the invocation name, ' + NUTANIX + ' unofficial.</p>' + \
                    '<p>If you have not yet registered your ' + NUTANIX + 'cluster, say, Cluster Registration</p></speak>'
    reprompt_text = '<speak><p>I didnt hear your request.</p></speak>'
    should_end_session = False
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_error_response():
    session_attributes = {}
    card_title = "Error"
    card_content = ""
    speech_output = '<speak><p>I am sorry, I dont understand your request</p></speak>'
    reprompt_text = ""
    should_end_session = True
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def model_error_response(intent, session):
    card_title = "CommunityEdition"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    speech_output = '<speak><p>This cluster is not a ' + NUTANIX + ' community edition.</p>' \
                    '<p>Only ' + NUTANIX + ' community edition can be managed with Alexa at this point in time</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_model():
        return (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['rackableUnits'][0]['modelName'])


def get_name(intent, session):
    card_title = "Cluster Name"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    speech_output = '<speak><p>The name of the cluster is ' + clusterName + '</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_memory_utilization(intent, session):
    card_title = "Cluster Utilization"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    hypervisor_memory_usage_ppm = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['stats']['hypervisor_memory_usage_ppm'])
    hypervisor_memory_usage_ppm = int(hypervisor_memory_usage_ppm) / 10000
    speech_output = '<speak><p>The memory utilization for the cluster ' + clusterName + ' is at ' + str(hypervisor_memory_usage_ppm) + ' percent</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_cpu_utilization(intent, session):
    card_title = "CPU Utilization"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    hypervisor_cpu_usage_ppm = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['stats']['hypervisor_cpu_usage_ppm'])
    hypervisor_cpu_usage_ppm = int(hypervisor_cpu_usage_ppm) / 10000
    speech_output = '<speak><p>The CPU utilization for the cluster ' + clusterName + ' is at ' + str(hypervisor_cpu_usage_ppm) + ' percent</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_hosts(intent, session):
    card_title = "Cluster Hosts"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    totalEntities = (json.loads(__request_cluster_hosts(ntnx_clusterIP, ntnx_clusterPort))['metadata']['totalEntities'])
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    speech_output = '<speak><p>The total number of hosts for the cluster ' + clusterName + '  is ' + str(totalEntities) + '</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_machines(intent, session):
    card_title = "Virtual Machines"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    totalEntities = (json.loads(__request_cluster_vms(ntnx_clusterIP, ntnx_clusterPort))['metadata']['totalEntities'])
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    speech_output = '<speak><p>There are ' + str(totalEntities) + ' virtual machines in the cluster ' + clusterName + '</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_health(intent, session):
    card_title = "Cluster Health"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    operationMode = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['operationMode'])
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    speech_output = '<speak><p>The health for cluster ' + clusterName + ' is ' + operationMode + '</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_alerts(intent, session):
    card_title = "Cluster Alerts"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True

    # Check if for alert type
    try:
        type = intent['slots']['type']['value']
    except Exception:
        type = "critical"

    totalEntities = (json.loads(__request_cluster_alerts(ntnx_clusterIP, ntnx_clusterPort, type))['metadata']['totalEntities'])
    clusterName = (json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))['entities'][0]['name'])
    speech_output = '<speak><p>There are ' + str(totalEntities) + ' ' + type + ' alerts in the ' + clusterName + ' cluster</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_summary(intent, session):
    card_title = "Cluster Summary"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True

    jsonObject = json.loads(__request_clusters(ntnx_clusterIP, ntnx_clusterPort))

    clusterName = jsonObject['entities'][0]['name']
    operationMode = jsonObject['entities'][0]['operationMode']
    hypervisor_memory_usage_ppm = int(jsonObject['entities'][0]['stats']['hypervisor_memory_usage_ppm']) / 10000
    hypervisor_cpu_usage_ppm = int(jsonObject['entities'][0]['stats']['hypervisor_cpu_usage_ppm']) / 10000
    totalEntitiesHosts = (json.loads(__request_cluster_hosts(ntnx_clusterIP, ntnx_clusterPort))['metadata']['totalEntities'])
    totalEntitiesAlerts = (json.loads(__request_cluster_alerts(ntnx_clusterIP, ntnx_clusterPort, "critical"))['metadata']['totalEntities'])
    totalEntitiesMachines = (json.loads(__request_cluster_vms(ntnx_clusterIP, ntnx_clusterPort))['metadata']['totalEntities'])

    speech_output = '<speak><p>Todays health summary for the ' + NUTANIX + ' cluster ' + clusterName + '</p>' + \
                    '<p>There are <break strength="medium"/>' + str(totalEntitiesHosts) + ' hosts, and ' + str(totalEntitiesMachines) + ', virtual machines in the cluster</p>' + \
                    '<p>and ' + str(totalEntitiesAlerts) + ' critical alerts</p>' + \
                    '<p>The overall cluster memory utilization is at ' + str(hypervisor_memory_usage_ppm) + ' percent</p>' + \
                    '<p>and the overal CPU utilization is at ' + str(hypervisor_cpu_usage_ppm) + ' percent</p>' + \
                    '<p>The overal cluster health is <break strength="strong"/>' + operationMode + '</p></speak>'

    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_stop_response(intent, session):
    card_title = "Stop"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = True
    speech_output = '<speak><p>Stopping</p></speak>'
    reprompt_text = ""
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def get_cluster_property(intent, session):
    card_title = "Cluster Property"
    card_content = ""
    session_attributes = session.get('attributes', {})
    should_end_session = False
    speech_output = '<speak><p>What property would you like to retrieve?</p></speak>'
    reprompt_text = '<speak><p>I didnt hear your request.</p></speak>'
    return build_response(session_attributes, build_speechlet_response(
        card_title, True, card_content, speech_output, reprompt_text, should_end_session))


def getCluster(intent, session):

    # Test for Community Edition
    #if get_model() != "CommunityEdition":
    #    return model_error_response(intent, session)

    try:
        type = intent['slots']['property']['value']
    except Exception:
        return get_error_response()

    if 'name' in intent['slots']['property']['value']:
        return get_name(intent, session)
    elif 'utilization' in intent['slots']['property']['value']:
        return get_memory_utilization(intent, session)
    elif 'health' in intent['slots']['property']['value']:
        return get_health(intent, session)
    elif 'hosts' in intent['slots']['property']['value']:
        return get_hosts(intent, session)
    elif 'alerts' in intent['slots']['property']['value']:
        return get_alerts(intent, session)
    elif 'summary' in intent['slots']['property']['value']:
        return get_summary(intent, session)
    elif 'property' in intent['slots']['property']['value']:
        return get_cluster_property(intent, session)
    elif 'machines' in intent['slots']['property']['value']:
        return get_machines(intent, session)
    elif 'registration' in intent['slots']['property']['value']:
        return cluster_registration(intent, session)
    else:
        return get_error_response()


def on_launch(launch_request, session):
    print("on_launch requestId=" + launch_request['requestId'] +
          ", sessionId=" + session['sessionId'])
    return get_welcome_response()


def on_intent(intent_request, session):
    print("on_intent requestId=" + intent_request['requestId'] +
          ", sessionId=" + session['sessionId'])

    intent = intent_request['intent']
    intent_name = intent_request['intent']['name']

    if intent_name == "GetCluster":
        return getCluster(intent, session)
    elif intent_name == "AMAZON.StopIntent" or intent_name == "AMAZON.CancelIntent":
        return get_stop_response(intent, session)
    elif intent_name == "AMAZON.HelpIntent":
        return get_help_response()
    else:
        return get_welcome_response()


def on_session_started(session_started_request, session):
    print("on_session_started requestId=" + session_started_request['requestId'] + ", sessionId=" + session['sessionId'])


def on_session_ended(session_ended_request, session):
    print("on_session_ended requestId=" + session_ended_request['requestId'] +
          ", sessionId=" + session['sessionId'])


def lambda_handler(event, context):

    logger.info('got event{}'.format(event))

    # Define request source and assign correct RDS instance
    __set_rds_host_region(event)

    # Retrieve cluster data for AlexaID
    if __request_userID_data(event['session']['user']['userId']) is None:
        return get_internal_error_response()

    if event['session']['new']:
        on_session_started({'requestId': event['request']['requestId']}, event['session'])
    if event['request']['type'] == "LaunchRequest":
        return on_launch(event['request'], event['session'])
    elif event['request']['type'] == "IntentRequest":
        return on_intent(event['request'], event['session'])
    elif event['request']['type'] == "SessionEndedRequest":
        return on_session_ended(event['request'], event['session'])


# Helpers that build all of the responses


def build_speechlet_response(title, ignore_card, content, output, reprompt_text, should_end_session):

    if ignore_card is True:
        return {
            'outputSpeech': {
                'type': 'SSML',
                'ssml': output
            },
            'reprompt': {
                'outputSpeech': {
                    'type': 'SSML',
                    'ssml': reprompt_text
                }
            },
            'shouldEndSession': should_end_session
        }

    else:
        return {
            'outputSpeech': {
                'type': 'SSML',
                'ssml': output
            },
            'card': {
                'type': 'Simple',
                'title': title,
                'content': content
            },
            'reprompt': {
                'outputSpeech': {
                    'type': 'SSML',
                    'ssml': reprompt_text
                }
            },
            'shouldEndSession': should_end_session
        }


def build_response(session_attributes, speechlet_response):
    return {
        'version': '1.0',
        'sessionAttributes': session_attributes,
        'response': speechlet_response
    }
