Limit your SSH logins using GeoIP
https://www.axllent.org/docs/view/ssh-geoip

install GeoIP country database
$apt-get install geoip-bin geoip-database

test
$ geoiplookup 8.8.8.8
GeoIP Country Edition: US, United States

The script
I wrote a simple shell script which returns either an true (ACCEPT) or false (DENY) response, and if it's a DENY it logs to the system messages (using logger). Save this file in /usr/local/bin/sshfilter.sh:

#!/bin/bash

# UPPERCASE space-separated country codes to ACCEPT
ALLOW_COUNTRIES="NZ AU"

if [ $# -ne 1 ]; then
  echo "Usage:  `basename $0` <ip>" 1>&2
  exit 0 # return true in case of config issue
fi

COUNTRY=`/usr/bin/geoiplookup $1 | awk -F ": " '{ print $2 }' | awk -F "," '{ print $1 }' | head -n 1`

[[ $COUNTRY = "IP Address not found" || $ALLOW_COUNTRIES =~ $COUNTRY ]] && RESPONSE="ALLOW" || RESPONSE="DENY"

if [ $RESPONSE = "ALLOW" ]
then
  exit 0
else
  logger "$RESPONSE sshd connection from $1 ($COUNTRY)"
  exit 1
fi
Edit the ALLOW_COUNTRIES to include a list of country codes you want your SSH server to accept connections from.

Note: is an IP address cannot be matched to a country (such as an internal IP address), the connection is accepted too (see the $COUNTRY = "IP Address not found").

Don't forget to make the script executable:

chmod 775 /usr/local/bin/sshfilter.sh
Lock down SSH
The last things we need to do is tell the ssh daemon (sshd) to deny all connections (by default) and to run this script to determine whether the connection should be allowed or not.

In /etc/hosts.deny add the line:

sshd: ALL
and in /etc/hosts.allow add the line

sshd: ALL: aclexec /usr/local/bin/sshfilter.sh %a
Testing
Obviously you want to test that this is working before you are accidentally logged out of your system. On the console I can do a test with the 8.8.8.8 which I happen to know is from the US, and in my case should be DENIED access. So:

/usr/local/bin/sshfilter.sh 8.8.8.8
The script will not return anything visible, however in /var/log/messages :
Jun 26 17:02:37 pi root: DENY sshd connection from 8.8.8.8 (US)

Do test a working connection too (via normal SSH)

After a while you should find results in your /var/log/messages along the lines of:
Jun 25 11:59:54 pi logger: DENY sshd connection from 82.221.102.185 (IS)
Jun 25 15:47:54 pi logger: DENY sshd connection from 220.227.123.122 (IN)
Jun 25 18:43:51 pi logger: DENY sshd connection from 221.229.166.252 (CN)

-----------------------------------------------------------------------------------------------------------------

update geoip

#!/bin/bash

cd /tmp
wget -q https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
if [ -f GeoIP.dat.gz ]
then
    gzip -d GeoIP.dat.gz
    rm -f /usr/share/GeoIP/GeoIP.dat
    mv -f GeoIP.dat /usr/share/GeoIP/GeoIP.dat
else
    echo "The GeoIP library could not be downloaded and updated"
fi
