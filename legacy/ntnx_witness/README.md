Short python script for Nutanix Metro Availability

config.py has the configuration parameter
listen.py uses simple sockets to receive a snmp trap
witness.py promotes the Standby-Site to active

Start the script with: python witness.py

If the script receives a trap (commandline example) like:

snmptrap -v1 -c public 127.0.0.1 1.3.6.1.4.1.20408.4.1.1.2 127.0.0.1 1 1 123 1.3.6.1.6.3.1.1.5.2 s siteB

where the name of the standby site is included the promotion takes place.

Please note that the socket listener is just an example. PySNMP is much better as SNMP receiver...
