#!/bin/ksh

createdg ()
{
su - grid << EOF
sqlplus / as sysasm <<END
CREATE DISKGROUP DATA EXTERNAL REDUNDANCY DISK '/dev/sdc','/dev/sdd','/dev/sde','/dev/sdf','/dev/sdg','/dev/sdh'
ATTRIBUTE 'au_size'='1M',
'compatible.asm' = '12.1',
'compatible.rdbms' = '12.1';
END
EOF
}
createdg
