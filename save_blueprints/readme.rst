Save Calm Blueprints
====================

Python 3.6 script to connect to Prism Central 5.9 or above and export all blueprints to JSON files.

Disclaimer
----------

This is *not* a production-grade script.  Please make sure you add appropriate exception handling and error-checking before running it in production.  See note re versions below, too.

Author
------

Chris Rasmussen, Solutions Architect, Nutanix (Melbourne, AU)

Changelog
---------

- 2018.09.21 - Script created

Details
-------

Connect to a Nutanix Prism Central instance, grab all Calm blueprints and save them to JSON files.

The intention is to use this script to take a quick backup of your Calm blueprints, without the need to manually export each one individually.

The other idea is for you, the user, to take this script and modify it to suit your requirements.

Requirements
------------

- Python3.6
- pip3 (to install requirements below, if you need to)
- requests
- urllib3
- pipenv (optional, but recommended)

Script Usage (Linux)
----------------------

::

    ./src/save_blueprints.py <prism_central_ip_address> [ --username username ] [ --password password ]

Screenshot
----------

.. image:: images/screenshot.png

Support
-------

These scripts are *unofficial* and are not supported or maintained by Nutanix in any way.

In addition, please also be advised that these scripts may run and operate in a way that do not follow best practices.  Please check through each script to ensure it meets your requirements.

**Changes will be required before these scripts can be used in production environments.**