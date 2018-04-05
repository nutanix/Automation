# alexa-skill

## Synopsis ##
The Alexa Skill for Nutanix provides natural language interaction with Nutanix cluster via AWS Alexa enabled devices. The code and samples presented below were created to be used with AWS infrastructure, specifically Alexa Skill Kit, AWS Lambda and AWS RDS MySQL. For additional information on how to use Alexa Skill for Nutanix refer to:
http://myvirtualcloud.net/getting-started-with-nutanix-skill-for-alexa/


## Author ##
Andre Leibovici (@andreleibovici)

## License ##
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Architecture
#
![alt text](https://github.com/nutanix/alexa-skill/blob/master/AlexaSkillArchitecture.jpg?raw=true "Architecture")
#
## Alexa Skill

##### Intent Schema
#
``
{
  "intents": [
    {
      "slots": [
        {
          "name": "property",
          "type": "LIST_OF_PROPERTIES"
        },
        {
          "name": "type",
          "type": "LIST_OF_ALERT_TYPES"
        }
      ],
      "intent": "GetCluster"
    },
    {
      "intent": "AMAZON.HelpIntent"
    },
    {
      "intent": "AMAZON.StopIntent"
    },
    {
      "intent": "AMAZON.CancelIntent"
    }
  ]
}
``

##### Custom Slot Types
#
``LIST_OF_ALERT_TYPES	critical | warning``

``LIST_OF_PROPERTIES	name | utilization | health | hosts | alerts | summary | property | registration | machines``
#
##### Sample Utterances
#
``GetCluster open Nutanix Unofficial``

``GetCluster ask Nutanix Unofficial to get cluster {property}``

``GetCluster ask Nutanix Unofficial for cluster {type} {property}``
#
---

## Lambda

**getCluster.py**
All imports must have been downloaded locally before uploading code in zip

**rds_config.py**
Configure database connection details (**must change**)

Note: RDS instance address for each region is hard-coded into getCluster.py (**must change**)
#
---
## RDS #
#
Create a MySQL RDS instance and run sql below to create DB.
The RDS database must be populated with the Nutanix cluster public IP and credentials. This may be done manually, or via a public web interface.

`
CREATE TABLE `alexa_beta` (
  `idalexa_beta` int(11) NOT NULL AUTO_INCREMENT,
  `alexa_userid` varchar(500) NOT NULL,
  `alexa_clusterip` varchar(45) NOT NULL,
  `alexa_username` varchar(45) NOT NULL,
  `alexa_password` varchar(45) NOT NULL,
  `alexa_nickname` varchar(45) NOT NULL,
  `alexa_clusterport` int(11) NOT NULL DEFAULT '9440',
  PRIMARY KEY (`idalexa_beta`),
  UNIQUE KEY `alexa_userid_UNIQUE` (`alexa_userid`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1
`
