#!/bin/sh

#
#  Script Name:  ntnx_end_backukpmode.sh
#
#  Description:  This script is to take an Oracle database out of backup mode
#
#  Author:  Tom Dau
#
#  Date Written:  4/30/2016
#
#  Revision:  1.0
#
# History:
# Date:         Who:            What:
#
#
#


f_endbackup ()
{
echo
echo "======================================================================"
echo
echo "Taking database ${SID} out of backup mode on `hostname`..."
echo
echo "======================================================================"
echo
su - oracle << EOF
export ORACLE_SID=${SID}
sqlplus "/ as sysdba" <<END
whenever sqlerror exit 1
whenever oserror exit 1
alter database end backup;
alter system archive log current;
END
EOF
RC=$?
if [ $RC -ne 0 ]; then
   echo
   echo 
   echo "**************************************************************"
   echo "ERROR: Taking database ${SID} out of backup mode failed..."
   echo "**************************************************************"
   echo
   echo 
   exit 1
fi
}

#############
## M A I N ##
#############

#
# Make sure we're running as root
#

OS=`uname`
case ${OS} in
        SunOS)  if [ `/usr/xpg4/bin/id -u` -ne 0 ] ; then
                    echo                                                         1>&2
                    echo                                                         1>&2
                    echo "`basename $0` - ERROR - Not executing as root."     1>&2
                    echo "                - Processing terminated."              1>&2
                    echo                                                         1>&2
                    exit 1
                fi;;
        *)      if [ `/usr/bin/id -u` -ne 0 ] ; then
                    echo                                                         1>&2
                    echo                                                         1>&2
                    echo "`basename $0` - ERROR - Not executing as root."     1>&2
                    echo "                - Processing terminated."              1>&2
                    echo                                                         1>&2
                    exit 1
                fi;;
esac

if [ $# -ne 1 ] ; then
   echo
   echo "Error: Must specify an Oracle SID..."
   echo
   echo "Ex. `basename $0` PRODDB"
   echo
   exit 1
fi

SID=$1

f_endbackup ${SID}
